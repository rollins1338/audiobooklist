#include <iostream>
#include <vector>
#include <cstdlib>
#include <ctime>
#include <thread>
#include <chrono>

// Configuration
const int WIDTH = 40;
const int HEIGHT = 20;
const int DELAY_MS = 200; // Speed of animation

class GameOfLife {
private:
    std::vector<std::vector<bool>> grid;
    int width, height;

public:
    GameOfLife(int w, int h) : width(w), height(h) {
        // Resize grid
        grid.resize(height, std::vector<bool>(width));

        // Seed random number generator
        std::srand(std::time(0));

        // Randomly initialize dead or alive cells
        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                // ~30% chance a cell starts alive
                grid[y][x] = (std::rand() % 100) < 30;
            }
        }
    }

    void draw() {
        // ANSI escape code to clear screen and move cursor to top-left
        std::cout << "\033[2J\033[H"; 

        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                if (grid[y][x]) {
                    std::cout << "O "; // Alive cell
                } else {
                    std::cout << ". "; // Dead cell
                }
            }
            std::cout << "\n";
        }
        std::cout << "--- Press Ctrl+C to stop ---" << std::endl;
    }

    int countNeighbors(int x, int y) {
        int count = 0;
        // Check 3x3 grid around the cell
        for (int i = -1; i <= 1; ++i) {
            for (int j = -1; j <= 1; ++j) {
                if (i == 0 && j == 0) continue; // Skip self

                // Wrap around edges (Toroidal grid)
                int nx = (x + j + width) % width;
                int ny = (y + i + height) % height;

                if (grid[ny][nx]) count++;
            }
        }
        return count;
    }

    void update() {
        std::vector<std::vector<bool>> newGrid = grid;

        for (int y = 0; y < height; ++y) {
            for (int x = 0; x < width; ++x) {
                int neighbors = countNeighbors(x, y);

                if (grid[y][x]) {
                    // Rule 1 & 2: Under/Overpopulation -> Dies
                    if (neighbors < 2 || neighbors > 3) {
                        newGrid[y][x] = false; 
                    }
                    // Rule 3: 2 or 3 neighbors -> Lives (stays true)
                } else {
                    // Rule 4: Reproduction -> Becomes alive
                    if (neighbors == 3) {
                        newGrid[y][x] = true;
                    }
                }
            }
        }
        grid = newGrid;
    }

    void run() {
        while (true) {
            draw();
            update();
            std::this_thread::sleep_for(std::chrono::milliseconds(DELAY_MS));
        }
    }
};

int main() {
    GameOfLife game(WIDTH, HEIGHT);
    game.run();
    return 0;
}
