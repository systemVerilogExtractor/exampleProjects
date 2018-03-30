# fpga_linear_time_sorter

a parallel sorting algorithm implemented in hardware that sorts data in linear time as it arrives serially

This algorithm is _fast_, since the sorting itself is done in parallel while the data is being input serially.
It is sorted and ready to be read back immediately following the last SPI write transfer.

The current project consists of stricly SystemVerilog files and uses no IP cores and is, hence, vendor-independent.
Altera Quartus project files are left as an example implementation.

## Tunable Parameters

* __DATA_WIDTH__ is width of the input value in bits.
While __DATA_WIDTH__ can be anywhere from 1 to N bits, the spi wrapper limits bit values to a multiple of bytes (8, 16, 32)
such that each element can be transferred as a series of 1 or more bytes within an spi frame.

* __SIZE__ is the maximum number of elements that can be stored in this peripheral.
An input unsorted may be any length of words up to SIZE elements long.

* __signed and unsigned__ input data, provided that you change the inputs/outputs like so

__UNSIGNED Version:__
    
    module sorting_cell
    #(parameter DATA_WIDTH = 8)
              ( input logic clk, reset, enable,
                input logic prev_cell_data_pushed,
                input logic prev_cell_state,
                input logic shift_up,
                input logic [(DATA_WIDTH-1):0] prev_cell_data,
                input logic [(DATA_WIDTH-1):0] new_data,
                input logic [(DATA_WIDTH-1):0] next_cell_data,
               output logic cell_data_is_pushed,
               output logic cell_state,
               output logic [(DATA_WIDTH-1):0] cell_data);

__SIGNED Version:__
    
    module sorting_cell
    #(parameter DATA_WIDTH = 8)
              ( input logic clk, reset, enable,
                input logic prev_cell_data_pushed,
                input logic prev_cell_state,
                input logic shift_up,
                input logic signed [(DATA_WIDTH-1):0] prev_cell_data,
                input logic signed [(DATA_WIDTH-1):0] new_data,
                input logic signed [(DATA_WIDTH-1):0] next_cell_data,
               output logic cell_data_is_pushed,
               output logic cell_state,
               output logic signed [(DATA_WIDTH-1):0] cell_data);

## Interface

Unsorted list data is transferred serially over an SPI interface.
An extra gpio pin (__write__) is devoted to indicate whether or not the interface is being used to write data (the unsorted list) or read data back (the sorted list). An extra pin is also devoted to resetting the peripheral.
The __write__ pin could be removed and the read/write signal could be input as the first SPI transfer, but it's an optimization for later.

The __reset__ pin must currently be toggled before sending a new input data.

SPI transfers are performed in __SPI_MODE_0__.

I mocked up some Arduino code to demo the interface.

__Note:__ I had to use shielded cable for the MISO, MOSI, and SCK lines to prevent crosstalk.

## FPGA Pinouts

| Pin   | type   | description                                                                                |
|-------|--------|--------------------------------------------------------------------------------------------|
| RESET | INPUT  | system reset                                                                               |
| MISO  | OUTPUT | (SPI) for outputting the sorted list elements                                              |
| MOSI  | INPUT  | (SPI) for inputting the unsorted list elements                                             |
| SCK   | INPUT  | (SPI) clock                                                                                |
| CS    | INPUT  | (SPI) chip-select                                                                          |
| WRITE | INPUT  | indicates whether or not spi transfers are inputs (unsorted list) or outputs (sorted list) |


## FPGA Resources

This isn't the most resource-thrifty project, but it hasn't been optimized as such.
It's current state is intended for clarity and readability.
A 256-length, 8-bit sorter costs approximately 5500 logical elements on an Altera Cyclone IV (or 25% of the total space).

This project kicked off as a thought experiment in a notebook on a winter airplane ride.
I'm glad to see it through.
