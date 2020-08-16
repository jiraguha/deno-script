async function offside(it) {
    const result = [];
    for await (const value of it) {
        result.push(value);
    }
    return result;
}

let dirs = offside(Deno.readDir('./'))
    .then((result) => {
        result.forEach(element => {
            console.log(element.name);
        });
    });
