package game

import rl "vendor:raylib"
import "./grid"

screen_width : i32 = 1000
screen_height : i32 = 1000

CELL_SIZE :: 5
CELL_COUNT_X :: 200
CELL_COUNT_Y :: 200

main :: proc() {
    gridOffset := rl.Vector2{0,0}

    gridInstance := grid.Make_Grid(
        CELL_COUNT_X,
        CELL_COUNT_Y,
        gridOffset,
        CELL_SIZE,
        rl.BLACK,
    )

    rl.SetTraceLogLevel(.WARNING)
    rl.InitWindow(screen_width, screen_height, "Sand Automata Simulator")
    defer rl.CloseWindow()

    rl.SetTargetFPS(60)

    for !rl.WindowShouldClose() {
        // Update
        rl.BeginDrawing()
        rl.ClearBackground(rl.BLACK)
        grid.Update(&gridInstance)
        grid.Draw(&gridInstance)
        rl.EndDrawing()
    }
}
