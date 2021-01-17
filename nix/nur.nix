let

  inherit (import ../channels) __nixPath;

in

import <nur> {
  repoOverrides.frobware = import <nur-frobware> {};
}
