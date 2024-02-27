import os
import glob
from shutil import copyfile


def run_testbench(mif_path):
    # Fetch all .mif files
    mif_files = glob.glob(os.path.join(mif_path, "*.mif"))

    # If data.mif is present, copy it's content to
    # verif/data.mif and remove it from the .mif list
    data_mif = os.path.join(mif_path, "data.mif")

    if data_mif in mif_files:
        print(f"Copying {data_mif} to verif\data.mif...")
        copyfile(data_mif, "verif\data.mif")
        mif_files.remove(data_mif)

    # For each .mif file, copy it's content to
    # verif/instruction.mif and run the testbench
    for instruction_mif in mif_files:
        print(f"Copying {instruction_mif} to verif\instruction.mif...")
        copyfile(instruction_mif, "verif\instruction.mif")

        print(f"Running testbench for {instruction_mif}...\n")
        os.system("vsim -c -do verif\modelsim_testbench")
        print()


def main():
    # Compile source files
    os.system("vlib work")
    os.system("vlog -f verif/modelsim_compile")
    print()

    # Fetch all subdirectories in the sim directory
    mif_paths = [os.path.join("sim", d) for d in os.listdir("sim")
                 if os.path.isdir(os.path.join("sim", d))]

    # For each subdirectory, run the testbenches
    for mif_path in mif_paths:
        run_testbench(mif_path)

    # Delete all .ver files in the verif directory
    ver_files = glob.glob("verif\*.ver")

    for ver_file in ver_files:
        os.remove(ver_file)

    # Delete work directory
    os.system("vdel -all -lib work")


if __name__ == "__main__":
    main()
