{ lib, ... }:
let
  inherit (lib)
    filterAttrs
    foldl
    mapAttrs'
    recursiveUpdate
    ;
in
{
  # Filter a generated set of attrs using a predicate function.
  #
  # mapFilterAttrs ::
  #   (name -> value -> bool)
  #   (name -> value -> { name = any; value = any; })
  #   attrs
  mapFilterAttrs = pred: f: attrs: filterAttrs pred (mapAttrs' f attrs);

  # Merge a list of attrs recursively, later values override previous ones.
  # recursiveMerge ::
  #   [ attrs ]
  #   attrs
  recursiveMerge = foldl recursiveUpdate { };
}
