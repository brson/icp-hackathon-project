export const PAGE_MODE_READ = 1;
export const PAGE_MODE_EDIT = 2;
export const PAGE_MODE_HISTORY = 3;

export function parseUrl(url) {
  console.log(`parsing url: ${url}`);

  const re = /^.*#\/(.+)$/;
  const matches = url.match(re);
  if (matches) {
    const pageDescription = matches[1];
    const re2 = /^(.+)\?(.+)$/;
    const matches2 = pageDescription.match(re2);
    if (matches2) {
      return {
        articleName: parsePageName(matches2[1]),
        articleMode: parsePageMode(matches2[2]),
      };
    } else {
      return {
        articleName: parsePageName(pageDescription),
        articleMode: PAGE_MODE_READ,
      };
    }
  } else {
    return {
      articleName: "index",
      articleMode: PAGE_MODE_READ,
    };
  }
}

function parsePageName(name) {
  if (name != "") {
    return name;
  } else {
    return "index";
  }
}

function parsePageMode(mode) {
  if (mode == "edit") {
    return PAGE_MODE_EDIT;
  } else if (mode == "history") {
    return PAGE_MODE_HISTORY;
  } else {
    return PAGE_MODE_READ;
  }
}
