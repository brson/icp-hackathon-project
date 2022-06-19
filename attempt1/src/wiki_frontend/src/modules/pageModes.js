export const MODE_READ = 1;

export function parseUrl(url) {
  console.log(`parsing url: ${url}`);

  return {
    articleName: "index",
    articleMode: MODE_READ,
  }
}
