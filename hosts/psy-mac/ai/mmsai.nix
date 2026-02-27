{
  mmsai = {
    "npm" = "@ai-sdk/openai-compatible";
    "name" = "MMS AI";
    "options" = {
      "baseURL" = "https://openai-api.mms-at-work.de/v1";
    };
    "models" = {
      "Devstral-Small-2-24B-Instruct-2512" = {
        name = "Devstral Small 24B (Code Optimized)";
        "limit" = {
          "context" = 128000;
          "output" = 32768;
        };
      };
      "codellama-34b" = {
        name = "CodeLlama 34B";
        "limit" = {
          "context" = 128000;
          "output" = 32768;
        };
      };
    };
  };
}
