import oomp
import copy

def load_parts(**kwargs):
    make_files = kwargs.get("make_files", True)
    #print "loading parts" plus the module name get the module name from the filename using __name__
    print(f"  loading parts {__name__}")
    create_generic(**kwargs)

def create_generic(**kwargs):
    print(f"  creating sellers")
    parts = []

    part_details = {}
    part_details["classification"] = "storage"
    part_details["type"] = "gridfinity"
    part_details["size"] = ""
    part_details["color"] = ""
    part_details["description_main"] = ""
    part_details["description_extra"] = ""
    part_details["manufacturer"] = ""
    part_details["part_number"] = ""

    default_empty = part_details.copy()

    #baseplate
    if True:
        default_current = copy.deepcopy(default_empty)
        default_current["size"] = "baseplate"

        #basic
        default_current = default_current.copy()
        default_current["color"] = "basic"


        #gridfinity_rebuilt
        if True:
            #rebuilt_baseplate
            local_default = copy.deepcopy(default_current)
            local_default["link_designer"] = "https://github.com/kennetek/gridfinity-rebuilt-openscad"
            local_default["link"] = "https://github.com/kennetek/gridfinity-rebuilt-openscad"
            local_default["link_generator"] = "https://gridfinity.perplexinglabs.com/pr/gridfinity-rebuilt/0/1"
            local_default["color"] = f"gridfinity_rebuilt"        
            
            #baseplate
            if True:
                local_default = copy.deepcopy(default_current)
                local_default["size"] = f"baseplate"        

                styles = ["thin", "skeletonized", "screw_together","weighted","screw_together_minimal"]
                sizes = []
                for x in range(1,4):
                    for y in range(1,4):
                        sizes.append(f"{x}_width_{y}_length")

                for style in styles:
                    for size in sizes:
                        current = copy.deepcopy(local_default)
                        
                        current["description_main"] = size
                        current["description_extra"] = style
                        parts.append(current)
                #bin
            if True:
                local_default = copy.deepcopy(default_current)
                local_default["size"] = f"bin"        

                styles = ["standard", "cylinder", "solid"]
                sizes = []
                for x in range(1,4):
                    for y in range(1,4):
                        for z in range(1,6):
                            sizes.append(f"{x}_width_{y}_length_{z}_unit_{int(z * 7)}_mm_height")

                for style in styles:
                    for size in sizes:
                        current = copy.deepcopy(local_default)                        
                        current["description_main"] = size
                        current["description_extra"] = style
                        parts.append(current)

        # trials
        if True:        
            local_default = copy.deepcopy(default_current)            
            local_default["size"] = f"test_style"


            """
            hiya chadikins I need a websearch and some info sorting into python format this website produced this # https://makerworld.com/en/models/888137-gridfinity-metric-screw-bins?from=search#profileId-843902 style = {} style["name_original"] = "gridfinity metric screw bins" style["designer"] = "morellid97" style["link"] = "https://makerworld.com/en/models/888137-gridfinity-metric-screw-bins?from=search#profileId-843902" style["note"] = "label added for metric screw sizes" styles.append(style) can I get it for
            """

            # https://makerworld.com/en/models/888137-gridfinity-metric-screw-bins?from=search#profileId-843902
            styles = []
            style = {}
            style["name_original"] = "gridfinity metric screw bins"
            style["designer"] = "morellid97"
            style["link"] = "https://makerworld.com/en/models/888137-gridfinity-metric-screw-bins?from=search#profileId-843902"
            style["note"] = "label added for metric screw sizes"
            styles.append(style)

            style = {}
            style["name_original"] = "Gridfinity Bins"
            style["designer"] = "Malux"
            style["link"] = "https://makerworld.com/en/models/1181046-gridfinity-bins"
            style["note"] = "Bins sized 1x1 to 1x4 (incl. finger scoops), 8mm magnet holes, optimized to print without supports/brim/raft."
            styles.append(style)



            for style in styles:
                current = copy.deepcopy(local_default)                
                current.update(style)
                current["color"] = f"{style['designer']}_designed_by".lower()
                current["description_main"] = f'{style["name_original"].replace(" ","_")}_style'.lower()
                parts.append(current)

        

        

        

    #ai and corel stuff
    if False:
        #image
        if True:
            count = 1
            for prompt in prompts:
            #creating actions                
                actions = []
                action = {}
                #- command: 'new_chat'
                action["command"] = "new_chat"  
                action["description"] = f"rice image {current["name"]}"
                actions.append(action)
                #- command: 'query'
                    #text: 'can i get some pictures of tourist attractions in hx2 halifax uk, please ensure it is definietly in the uk and has the post code hx2?'
                action = {}
                action["command"] = "query"
                action["text"] = prompt
                action["delay"] = 60
                actions.append(action)
                
                action = {}
                #- command: 'save_image'
                action["command"] = "save_image_generated"  
                action["file_name"] = f"initial_generated_cgi.png"
                actions.append(action)


                #- command: 'add_image'
                action = {}
                action["command"] = "add_image"
                action["file_name"] = f"initial_generated_{count}.png"           
                actions.append(action)

                #close tab
                action = {}
                action["command"] = "close_tab"
                actions.append(action)

                base  = {}
                base["actions"] = copy.deepcopy(actions)
                file_test = f"initial_generated_{count}.png"
                base["file_test"] = file_test
                part[f"oomlout_ai_roboclick_{count}"] = base
                count += 1
        
        #trace
        if True:
            #trace file
            count = 1
            for prompt in prompts:
                if True:
                    actions = []

                    #wait_for_file initial_generation.png
                    action = {}
                    action["command"] = "wait_for_file"
                    action["file_name"] = f"initial_generated_{count}.png"                
                    actions.append(copy.deepcopy(action))

                    action = {}
                    action["command"] = "corel_trace_full"
                    action["file_source"] = f"source_files\\working_landscape\\working.cdr"
                    action["file_source_trace"] = f"initial_generated_{count}.png"
                    action["file_destination"] = f"trace_{count}.cdr"
                    action["max_dimension"] = 150
                    #cordinates 31,50
                    action["x"] = 75
                    action["y"] = 50
                    actions.append(copy.deepcopy(action))
                    
                    base  = {}
                    base["actions"] = copy.deepcopy(actions)
                    #the file that is created so skips if done
                    file_test = f"trace_{count}.png"
                    base["file_test"] = file_test
                    part["oomlout_corel_roboclick_1"] = base

        #trace
                

        
        
        parts.append(part)
    



    oomp.add_parts(parts, **kwargs)

    import time
    time.sleep(2)


if __name__ == "__main__":
    # run the function
    load_parts()    
    