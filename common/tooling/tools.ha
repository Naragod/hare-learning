

export fn apply(func: *fn(x: int...) int, args: int...) int = func(args...);

export fn reduce(func: *fn(acc: int, item: int) int, args: int...) int = {
    let aggregate = 0;

    for(let arg .. args){
        aggregate = func(aggregate, arg);
    };

    return aggregate;
};