"""Check evaluated OpenCode settings from stdin without executing shell commands.

The matcher models documented V2 wildcards; runtime scanner/config-loading checks
are separate. Pass `nix eval --json ...programs.opencode.settings` on stdin.
"""

import json
import re
import sys
import unittest

CONFIG = json.load(sys.stdin)
BASE = [
    {"action": "*", "resource": "*", "effect": "allow"},
    {"action": "read", "resource": "*.env", "effect": "ask"},
    {"action": "read", "resource": "*.env.*", "effect": "ask"},
    {"action": "read", "resource": "*.env.example", "effect": "allow"},
]
EXPLORE = [
    {"action": "*", "resource": "*", "effect": "deny"},
    *[
        {"action": action, "resource": "*", "effect": "allow"}
        for action in (
            "shell",
            "read",
            "glob",
            "grep",
            "webfetch",
            "websearch",
            "external_directory",
        )
    ],
    *BASE[1:],
    {"action": "subagent", "resource": "*", "effect": "deny"},
]


def matches(pattern, value):
    """V2 whole-value wildcards, including the optional trailing argument list."""
    optional_args = pattern.endswith(" *")
    if optional_args:
        pattern = pattern[:-2]
    pattern = re.escape(pattern).replace(r"\*", ".*").replace(r"\?", ".")
    if optional_args:
        pattern += "(?: .*)?"
    return re.fullmatch(pattern, value, re.DOTALL) is not None


def effect(rules, action, resource):
    result = "ask"
    for rule in rules:
        if matches(rule["action"], action) and matches(rule["resource"], resource):
            result = rule["effect"]
    return result


class Permissions(unittest.TestCase):
    def rules(self, agent):
        return (
            BASE
            + (EXPLORE if agent == "explore" else [])
            + CONFIG["permissions"]
            + CONFIG["agents"].get(agent, {}).get("permissions", [])
        )

    def assert_shell(self, commands, expected):
        for agent in (
            "build",
            "plan",
            "explore",
            "general",
            "implementer",
            "orchestrator-build",
            "codereviewer",
        ):
            for command in commands:
                with self.subTest(agent=agent, command=command):
                    self.assertEqual(
                        effect(self.rules(agent), "shell", command), expected
                    )

    def test_routine_work(self):
        self.assert_shell(
            [
                "ls",
                "rg pattern .",
                "awk '{print $1}' input",
                "wc -l input",
                "git show HEAD",
                "git -C package diff",
                "cargo test -p example",
                "cargo clippy --all-targets -- -D warnings",
                "direnv exec . cargo test",
                "nix develop -c cargo test",
                "npm test",
                "pnpm build",
                "go test ./...",
                "mvn test",
                "./gradlew test",
                "helm template example .",
                "helm list",
                "kubectl get pods",
                "kubectl --context example logs pod/example",
                "kubectl rollout status deployment/example",
                "gh issue view 4",
                "gh api repos/example/project/issues",
            ],
            "allow",
        )

    def test_high_impact_guardrails(self):
        self.assert_shell(
            [
                "sudo",
                "sudo -u root id",
                "doas id",
                "git push",
                "git push origin main",
                "git -C package push origin main",
                "git -c example=value reset --hard HEAD",
                "git clean -fd",
                "gh pr merge 1",
                "gh --repo example/project pr merge 1",
                "gh repo delete example/project",
                "gh --repo example/project repo delete",
                "kubectl apply -f example.yaml",
                "kubectl create namespace example",
                "kubectl --context example delete pod example",
                "kubectl replace -f example.yaml",
                "kubectl patch deployment example",
                "kubectl edit deployment example",
                "kubectl scale deployment example --replicas=0",
                "kubectl rollout restart deployment/example",
                "kubectl rollout undo deployment/example",
                "helm install example .",
                "helm --kube-context example upgrade example .",
                "helm uninstall example",
                "helm rollback example 1",
            ],
            "ask",
        )

    def test_known_matching_limits(self):
        # Deliberate guardrail gaps, not claims of security containment.
        self.assert_shell(
            [
                "direnv exec . git push",
                "bash -c 'git push'",
                "GIT_TERMINAL_PROMPT=0 git push",
                "KUBECONFIG=example kubectl delete pod example",
                "gh api --method DELETE example",
            ],
            "allow",
        )
        # Middle wildcards also catch matching text in unrelated arguments.
        self.assert_shell(["git stash push -m example", "git log --grep=push"], "ask")

    def test_boundaries(self):
        for agent in ("build", "explore", "codereviewer"):
            for action, resource, expected in [
                ("external_directory", "/nix/store/*", "allow"),
                ("external_directory", "/nix/store/example-source/*", "allow"),
                ("external_directory", "/nix/store-other/*", "ask"),
                ("external_directory", "/outside/*", "ask"),
                ("read", "/nix/store", "allow"),
                ("read", "/nix/store/example-source/.env", "allow"),
                ("edit", "/nix/store", "deny"),
                ("edit", "/nix/store/example-source/default.nix", "deny"),
                ("read", "project/.env", "ask"),
                ("read", "project/.env.example", "allow"),
            ]:
                with self.subTest(agent=agent, action=action, resource=resource):
                    self.assertEqual(
                        effect(self.rules(agent), action, resource), expected
                    )

    def test_non_editing_agents(self):
        for agent in ("explore", "codereviewer"):
            self.assertIn("permissions", CONFIG["agents"][agent])
            rules = self.rules(agent)
            with self.subTest(agent=agent, action="edit"):
                self.assertEqual(effect(rules, "edit", "project/file"), "deny")
            for action in (
                "subagent",
                "execute",
                "question",
                "skill",
                "unknown_tool",
                "grep_app_searchGitHub",
                "opencode_read_mcp_resource",
                "read",
                "glob",
                "grep",
                "webfetch",
                "websearch",
            ):
                with self.subTest(agent=agent, action=action):
                    self.assertEqual(effect(rules, action, "example"), "allow")

    def test_nested_delegation(self):
        self.assertEqual(CONFIG["experimental"]["subagent_depth"], 2)

    def test_shared_shell_order(self):
        shared = [r for r in CONFIG["permissions"] if r["action"] == "shell"]
        for agent in ("explore", "codereviewer"):
            rules = [
                r
                for r in CONFIG["agents"][agent]["permissions"]
                if r["action"] == "shell"
            ]
            self.assertEqual(shared, rules)
        self.assertEqual(
            shared[0], {"action": "shell", "resource": "*", "effect": "allow"}
        )
        self.assertTrue(all(r["effect"] == "ask" for r in shared[1:]))


if __name__ == "__main__":
    unittest.main()
