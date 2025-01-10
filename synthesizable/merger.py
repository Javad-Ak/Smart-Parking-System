import os

# Path to the source directory
src_dir = "./src"
output_file = "./synthesizable/prod.v"

def merge_files(src_dir, output_file):
    merged_content = []

    for filename in os.listdir(src_dir):
        if filename.endswith(".v") and not filename.endswith("_tb.v"):
            filepath = os.path.join(src_dir, filename)
            with open(filepath, 'r') as file:
                content = file.read()

            merged_content.append("\n\n")
            merged_content.append(content)
            merged_content.append("\n\n")

    with open(output_file, 'w') as outfile:
        outfile.writelines(merged_content)

# Run the merge
merge_files(src_dir, output_file)
