use fmt;
use strconv;
use tooling;

fn add(x: int...) int = {
    let sum = 0;
    for(let i .. x){
        sum += i;
    };
    return sum;
};

fn double(aggregate: int, item: int) int = {
    fmt::printfln("aggregate: {}, item: {}", strconv::itos(aggregate), strconv::itos(item))!;
    const result = aggregate + (item + item);
    return result;
};

export fn main() void = {
    // const sum = tooling::apply(&add, 1, 2, 3);
    // fmt::printfln("Sum: {}", strconv::itos(sum))!;

    const numbers = [1,2,3,4,5];
    const result = tooling::reduce(&double, numbers...);
    fmt::printfln("Sum: {}", strconv::itos(result))!;

};