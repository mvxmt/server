{pkgs}: {
  fetchGithubKeys = {username, hash}: toString (pkgs.fetchurl {
    inherit hash;
    url = "https://github.com/${username}.keys";
  });
}