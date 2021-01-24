{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
      aspell
      aspellDicts.en
      aspellDicts.en-computers
      aspellDicts.en-science
      hunspell
      hunspellDicts.en-gb-ise
      hunspellDicts.en-us
      ispell
  ];
}
