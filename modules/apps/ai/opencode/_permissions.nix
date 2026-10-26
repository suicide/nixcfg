let
  # These are direct-command accident guardrails, not a sandbox. Wrappers and
  # scripts can bypass them; middle wildcards can also prompt on harmless text.
  shell =
    [
      {
        action = "shell";
        resource = "*";
        effect = "allow";
      }
    ]
    ++ map (resource: {
      action = "shell";
      inherit resource;
      effect = "ask";
    }) [
      "sudo *"
      "doas *"
      "git *push *"
      "git *reset *"
      "git *clean *"
      "gh *pr merge *"
      "gh *repo delete *"
      "kubectl *apply *"
      "kubectl *create *"
      "kubectl *delete *"
      "kubectl *replace *"
      "kubectl *patch *"
      "kubectl *edit *"
      "kubectl *scale *"
      "kubectl *rollout restart *"
      "kubectl *rollout undo *"
      "helm *install *"
      "helm *upgrade *"
      "helm *uninstall *"
      "helm *rollback *"
    ];

  directories = [
    {
      action = "external_directory";
      resource = "*";
      effect = "ask";
    }
    {
      action = "external_directory";
      resource = "${builtins.storeDir}/*";
      effect = "allow";
    }
    {
      action = "read";
      resource = builtins.storeDir;
      effect = "allow";
    }
    {
      action = "read";
      resource = "${builtins.storeDir}/*";
      effect = "allow";
    }
    {
      action = "edit";
      resource = builtins.storeDir;
      effect = "deny";
    }
    {
      action = "edit";
      resource = "${builtins.storeDir}/*";
      effect = "deny";
    }
  ];

  sensitiveReads = [
    {
      action = "read";
      resource = "*.env";
      effect = "ask";
    }
    {
      action = "read";
      resource = "*.env.*";
      effect = "ask";
    }
    {
      action = "read";
      resource = "*.env.example";
      effect = "allow";
    }
  ];

  shared = sensitiveReads ++ directories ++ shell;
in {
  inherit shared;

  # Override Explore's built-in tool denials, then restore shared guardrails.
  # Only direct edits are blocked; shell/MCP execution is not containment.
  nonEditing =
    [
      {
        action = "*";
        resource = "*";
        effect = "allow";
      }
    ]
    ++ shared
    ++ [
      {
        action = "edit";
        resource = "*";
        effect = "deny";
      }
    ];
}
