class Node:
    def __init__(self, name, subdirectories: dict, file_sizes, parent):
        self.name = name
        self.subdirectories = subdirectories
        self.file_sizes = file_sizes
        self.parent = parent

    def update_subdirectories(self, subdir_name, subdir_node):
        # Need this because python is assuming it's a list if I don't make the 
        # dict as such
        if len(self.subdirectories)==0:
            self.subdirectories = {subdir_name: subdir_node}

        else:
            self.subdirectories[subdir_name] = subdir_node


class Tree:
    def __init__(self, root):
        Tree.root = root
    
    def get_sizes_under_thresh_helper(self, node, curr_total, sizes_list):
        subdirs = node.subdirectories.values()
        
        if len(node.subdirectories)==0:
            sizes_list.append(sum(node.file_sizes))
            return sum(node.file_sizes)
            
        size_below = 0
        for sub_node in subdirs:
            size_below += self.get_sizes_under_thresh_helper(sub_node, curr_total, sizes_list)

        size_of_this_node = size_below + sum(node.file_sizes)
        sizes_list.append(size_of_this_node)
        return size_of_this_node

    def get_sizes_under_thresh(self):
        curr_total = 0
        sizes_list = []
        total_size = self.get_sizes_under_thresh_helper(self.root, curr_total, sizes_list)
        return sizes_list



def collect_ls_output(data, start_line):
    next_command_found = False
    full_output = []
    curr_line = start_line

    while( next_command_found==False and curr_line < len(data)):
        line = data[curr_line]
        if line.startswith("$") or line=="":
            next_command_found = True
            return full_output
        
        full_output.append(line)
        curr_line += 1

        

def parse_input(data):
    # assumes data has 2 empty lines at end. Sorry, I don't make the rules :)
    this_tree = Tree(Node("/", [], [], None))
    curr_node = this_tree.root

    for i,line in enumerate(data[1:]):
        # handle cd commands
        if line.startswith("$ cd"):
            new_node = line.split(" ")[-1]
            if new_node=="..":
                curr_node = curr_node.parent
            else: 
                curr_node = curr_node.subdirectories[new_node]

        if line.startswith("$ ls"):
            # have to use i+1 to increment to next line
            # and we want the next line(s), not our current
            output = collect_ls_output(data[1:], i+1)

            # loop through the ls output
            for out_line in output:
                # handle a new directory
                if out_line.startswith("dir"):
                    subdir = out_line.split(" ")[-1]
                
                    created_node = Node(subdir, 
                                        subdirectories=dict(),
                                        file_sizes=[],
                                        parent=curr_node)

                    curr_node.update_subdirectories(subdir, created_node)

                # handle a new file size
                else:
                    size = int(out_line.split(" ")[0])
                    curr_node.file_sizes.append(size)

            # print(f"{curr_node.name} contains",
            #      f"subdirectories {list(curr_node.subdirectories.keys())}")
    return this_tree
    


def solution(file, threshold, size_needed):
    with open(file, "r") as f:
        data = [x.strip() for x in f.readlines()]
    
    tree = parse_input(data)
    sizes_under = tree.get_sizes_under_thresh()
    print("Part 1 answer: ",
          sum([x for x in sizes_under if x < threshold]))

    total = sizes_under[-1] 
    curr_remaining = 70000000 - total
    min_size = size_needed - curr_remaining
    print(f"Minimum file size needed to be deleted: {min_size}")
    print("Size of smallest file over that limit:", 
          min([x for x in sizes_under if x > min_size]),
          " (Part 2 answer)")



if __name__=="__main__":
    my_node = Node("/", [], [], None)
    Tree(my_node)

    test = "Day-7-data.txt"
    threshold = 100000
    size_needed = 30000000
    solution(test, threshold, size_needed)

