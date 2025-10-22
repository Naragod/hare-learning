use fmt;
use strings;
use strconv;

const BG_YELLOW = "\x1b[43m"; // Background Yellow
const FG_BLACK = "\x1b[30m"; // Foreground Black
const RESET_COLOR = "\x1b[0m"; // Reset to default

export type cell = enum {EMPTY, X, O};
export type player_turn = enum {FIRST, SECOND};
export type coordinate = struct {x: int, y: int};
export type board = struct {
    message: str,
    grid: [][]cell,
    turn: player_turn,
    position: coordinate,
    game_has_ended: bool
};

export fn switch_player(player: player_turn) player_turn = {
    switch(player){
        case player_turn::FIRST => return player_turn::SECOND;
        case player_turn::SECOND => return player_turn::FIRST;
    };
};

export fn player_to_cell(player: player_turn) cell = {
    switch (player) {
        case player_turn::FIRST => return cell::X;
        case player_turn::SECOND => return cell::O;
    };
};

export fn cell_to_char(c: cell) str = {
    switch (c) {
        case cell::X => return "X";
        case cell::O => return "O";
        case cell::EMPTY => return "_";
    };
};

export fn parse_coordinates(user_string: str) coordinate = {
    const split_input: []str = strings::split(user_string, ",")!;
    const y = strconv::stoi(split_input[0])!:int;
    const x = strconv::stoi(split_input[1])!:int;
    
    return coordinate {x = x, y = y};
};


export fn update_board(player_board: board, play_at: coordinate) board = {
    const play_cell:cell = player_board.grid[play_at.x][play_at.y];

    if(play_cell != cell::EMPTY){
        return fmt::fatalf("INVALID POSITION");
    };
    // set current position to latest input
    player_board.position = play_at;
    // update player cell either X or O
    player_board.grid[play_at.x][play_at.y] = player_to_cell(player_board.turn);
    
    // set game state
    player_board.game_has_ended = check_winning_state(player_board);

    // switch player
    player_board.turn = switch_player(player_board.turn);

    return player_board;
};

export fn check_winning_state(player_board: board) bool = {
    const inverse_cond = 0;
    const diagonal_cond = 0;
    const grid = player_board.grid;
    const grid_size = len(grid) - 1;
    const player = player_to_cell(player_board.turn);

    for(let col = 0: size; col < len(grid); col += 1){
        const row_cond = 0;
        const col_cond = 0;
        
        // check diagonals
        const diagonal_tick = grid[i][i];
        const inverse_tick = grid[i][grid_size - i];

        if(diagonal_tick == player){
            diagonal_cond += 1;
        };
        if(inverse_tick == player){
            inverse_cond += 1;
        };

        // check rows && columns
        for(let row = 0: size; row < len(grid[col]); row += 1){
            const row_tick = grid[col][row];
            const col_tick = grid[row][col];
            
            if(row_tick == player){
                row_cond += 1;
            };
            if(col_tick == player){
                col_cond += 1;
            };
        };

        if(row_cond == 3 || col_cond == 3){
            return true;
        };

        if(diagonal_cond == 3 || inverse_cond == 3){
            return true;
        };
    };
    return false;
};

export fn draw_board(player_board: board) void = {
    const message = player_board.message;
    const position = player_board.position;
    const grid: [][]cell = player_board.grid;
    const player: player_turn = player_board.turn;
    const player_cell = cell_to_char(player_to_cell(player));

    fmt::printfln("Player {}'s move", player_cell)!;
    fmt::println("Enter a valid x, y position")!;

    for(let col = 0: size; col < len(grid); col += 1){
        const row_arr: []str = [];

        for(let row = 0: size; row < len(grid[col]); row += 1){
            const grid_char = cell_to_char(grid[col][row]);

            if(row == position.y: size && col == position.x: size){
                const color_char = strings::join("", BG_YELLOW, FG_BLACK, grid_char, RESET_COLOR)!;
                append(row_arr, color_char)!;
                continue;
            };
            append(row_arr, grid_char)!;
        };
        const row_str = strings::join(" ", row_arr...)!;
        fmt::println(row_str)!;
    };
    fmt::printfln("Message: {}", message)!;
};
