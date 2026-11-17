{config, ...}: {
  config = {
    __cfg.opencode = {};

    programs.opencode = {
      settings = {
        agents = let
          deepseekFlash = "opencode-go/deepseek-v4.1-flash";
          exploreModel = generalModel;
          buildModel = deepseekFlash;
          implementerModel = buildModel;
          generalModel = buildModel;
          reviewerModel = "openai/gpt-6.1-terra";
          docsModel = reviewerModel;
        in {
          # Built in
          build = {
            model = buildModel;
          };
          explore = {
            model = exploreModel;
          };
          general = {
            model = generalModel;
          };

          # extras

          documentation = {
            model = docsModel;
          };
          codereviewer = {
            model = reviewerModel;
          };
          domainreviewer = {
            model = reviewerModel;
          };
          productreviewer = {
            model = reviewerModel;
          };
          implementer = {
            model = implementerModel;
          };
        };
      };
    };
  };
}
