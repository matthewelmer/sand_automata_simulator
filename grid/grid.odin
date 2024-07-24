package grid

import rl "vendor:raylib"
import "core:math/rand"
import "core:math"

// Grid
Grid :: struct {
    width, height: int,
    offset_pos: rl.Vector2,
    blockSize: f32,
    cells: [][]CELL_TYPE,

    backgroundColor: rl.Color,
    fall_speed: f32,
}

CELL_TYPE :: enum {
    EMPTY,
    SAND,
    WATER,
}

globalTimeCounter : f32 = 0.0

Make_Grid :: proc(width : int, height : int, offset_pos: rl.Vector2,blockSize: f32,  backgroundColor: rl.Color) -> Grid {
    g := Grid{
        width = width,
        height = height,
        blockSize = blockSize,
        offset_pos = offset_pos,
        backgroundColor = backgroundColor,
    }

    cells := make([][]CELL_TYPE, width)
    for i in 0..< width {
        cells[i] = make([]CELL_TYPE, height)
    }
    g.fall_speed = fall_speed

    g.cells = cells
    return g
}

fall_time : f32 = 0.0
fall_speed : f32 = 100

// Update the grid
Update :: proc(g : ^Grid) {

    get_input(g)
    fall_time += rl.GetFrameTime()
    if fall_time >= 1/g.fall_speed {
        drop_sand(g)
        fall_time = 0
    }

}

get_input :: proc(g : ^Grid) {
    mouse_pos := rl.GetMousePosition()
    if rl.IsMouseButtonDown(rl.MouseButton.LEFT) {
        x := int((mouse_pos.x - g.offset_pos.x) / g.blockSize)
        y := int((mouse_pos.y - g.offset_pos.y) / g.blockSize)
        if x >= 0 && x < g.width && y >= 0 && y < g.height {
            g.cells[x][y] = CELL_TYPE.SAND
        }
    }
}

drop_sand :: proc(g : ^Grid) {
    new_cells := make([][]CELL_TYPE, g.width)
    for i in 0..< g.width {
        new_cells[i] = make([]CELL_TYPE, g.height)
    }
    for i in 0..< g.width {
        for j in 0..< g.height {
            cell := g.cells[i][j]
            if cell == CELL_TYPE.SAND {
                if j + 1 < g.height {
                    if g.cells[i][j+1] == CELL_TYPE.EMPTY {
                        new_cells[i][j] = CELL_TYPE.EMPTY
                        new_cells[i][j+1] = CELL_TYPE.SAND
                    }
                    else if g.cells[i][j+1] == CELL_TYPE.SAND{
                        new_cells[i][j] = CELL_TYPE.SAND
                    } 
                } else {
                    new_cells[i][j] = CELL_TYPE.SAND
                }
            }
        }
    }
    //delete g.cells
    // for col in g.cells {
    //     delete(col)
    // }
    // delete(g.cells)
    g.cells = new_cells
}

// Draw the grid
Draw :: proc(g : ^Grid) {
    rl.DrawRectangle(i32(g.offset_pos.x), i32(g.offset_pos.y), i32(f32(g.width)*g.blockSize -1), i32(f32(g.height)*g.blockSize -1), rl.WHITE)
    for i in 0..< g.width {
        for j in 0..< g.height {
            cell := g.cells[i][j]
            x := f32(i) * g.blockSize + g.offset_pos.x
            y := f32(j) * g.blockSize + g.offset_pos.y
            width := g.blockSize - 1
            height := g.blockSize - 1
            color := rl.BLACK
            if cell == CELL_TYPE.SAND {
                color = rl.WHITE
            }
            rl.DrawRectangle(i32(f32(i) * g.blockSize + g.offset_pos.x), i32(f32(j) * g.blockSize + g.offset_pos.y), i32(g.blockSize) -1, i32(g.blockSize) - 1, color)
        }
    }
}
