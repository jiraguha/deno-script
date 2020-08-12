async function ofside(it) {
    const result = [];
    for await (const value of it) {
      result.push(value);
    }
    return result;
}
  
let dirs = ofside(Deno.readDir("./"))
          .then((result) => {
              result.forEach(element => {
                  console.log(element.name)
              });
          });
