from math import log2

PIC_WIDTH = 256
COLOR_DEPTH = 5

if __name__ == "__main__":
    with open("t.mif", "w", newline='') as file:
        file.write(f"WIDTH={PIC_WIDTH * COLOR_DEPTH};\n"
                   f"DEPTH={PIC_WIDTH};\n"
                   f"ADDRESS_RADIX = BIN;\n"
                   f"DATA_RADIX = BIN;\n"
                   f"CONTENT\n"
                   f"BEGIN\n")
        j = 0
        bin_format0 = '{0:0' + str(int(log2(PIC_WIDTH))) + 'b}'
        bin_format1 = '{0:0' + str(COLOR_DEPTH) + 'b}'
        for i in range(PIC_WIDTH):
            file.write(bin_format0.format(i) + ' : ' + bin_format1.format(j) * PIC_WIDTH + ';\n')
            if j == 31:
                j = 0
            else:
                j += 1
        file.write("END;")
