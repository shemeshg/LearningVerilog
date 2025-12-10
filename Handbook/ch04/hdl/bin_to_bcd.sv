import types_pkg::*;
module bin_to_bcd (
    input word_t bin,
    output logic [DIGITS*4-1:0] bcd
);

  integer i, j;
  logic [DIGITS*4-1:0] temp;
  word_t bin_work;  // local copy

  // to put 10 at end of number
  int first_used;
  bit found;

  always_comb begin


    // copy input into a local variable
    bin_work = bin;

    // Initialize
    for (j = 0; j < DIGITS; j++) temp[j*4+:4] = 4'd00;

    // Double dabble
    for (i = BITS - 1; i >= 0; i--) begin
      // Add 3 if >= 5
      for (j = 0; j < DIGITS; j++) begin
        if (temp[j*4+:4] >= 5) temp[j*4+:4] = temp[j*4+:4] + 3;
      end

      // Shift left: concatenate temp and bin_work
      {temp, bin_work} = {temp, bin_work} << 1;
    end

    // Assign result
    bcd = temp;



    first_used = DIGITS;

    found = 0;

    for (j = 0; j < DIGITS; j++) begin
      if (!found && bcd[(DIGITS*4-1)-j*4-:4] != 0) begin
        first_used = j;
        found = 1;
      end
    end
    // Overwrite unused upper digits with 10
    for (j = first_used; j < DIGITS; j++) begin
      bcd[j*4+:4] = 4'd10;
    end
  end
endmodule
