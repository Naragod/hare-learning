use fmt;
use bufio;
use os;
use fs;
use io;
use tooling;

export fn main() void = {
    let player_board = tooling::board {
        message:str = "...",
        turn = tooling::player_turn::FIRST,
        position = tooling::coordinate {x = 0, y = 0},
        grid: [3][3]tooling::cell = [
            [tooling::cell::EMPTY, tooling::cell::EMPTY, tooling::cell::EMPTY],
            [tooling::cell::EMPTY, tooling::cell::EMPTY, tooling::cell::EMPTY],
            [tooling::cell::EMPTY, tooling::cell::EMPTY, tooling::cell::EMPTY]
        ]
    };

    for(true){
        tooling::clear_screen();
        tooling::draw_board(player_board);
        const user_string = tooling::read_line();
        
        if(user_string == "quit" || user_string == "__end__"){
            break;
        };

        const position = tooling::parse_coordinates(user_string);
        player_board = tooling::update_board(player_board, position);
        const has_won = tooling::check_winning_state(player_board);

        if(has_won){
            const player = tooling::player_to_cell(player_board.turn);
            fmt::printfln("Player: {} won", tooling::cell_to_char(player))!;
            break;
        };
    };
    fmt::printfln("Program terminated")!;
};
