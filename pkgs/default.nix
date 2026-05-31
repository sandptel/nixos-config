final: prev: {
  # Custom packages exposed as an overlay.
  custom-tool = prev.callPackage ./custom-tool { };
}
