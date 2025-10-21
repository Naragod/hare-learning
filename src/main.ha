use fmt;
use bufio;
use os;
use fs;
use io;
use tooling;

export fn main() void = {
    let player_board = tooling::board {
        message:str = "...",
        game_has_ended = false,
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
        const has_won = player_board.game_has_ended;

        if(has_won){
            const winner = tooling::switch_player(player_board.turn);
            const player = tooling::player_to_cell(winner);
            fmt::printfln("Player: {} won", tooling::cell_to_char(player))!;
            break;
        };
        const user_string = tooling::read_line();
        
        if(user_string == "quit" || user_string == "__end__"){
            break;
        };

        const position = tooling::parse_coordinates(user_string);
        player_board = tooling::update_board(player_board, position);
    };
    fmt::printfln("Program terminated")!;
};
