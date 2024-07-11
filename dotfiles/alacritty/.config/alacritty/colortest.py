print("Color codes for your terminal:")
for i in range(0, 16):
    for j in range(0, 16):
        code = str(i * 16 + j)
        print(f"The code being {code}: \033[48;5;{code}m {code.ljust(4)}\033[0m", end="\n")
    print()
