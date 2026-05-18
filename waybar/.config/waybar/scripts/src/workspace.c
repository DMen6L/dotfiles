#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <json-c/json.h>

typedef struct {
    int id;
    const char *name;
    const char *icon;
    int active;
} Workspace;

const char* get_workspace_icon(const char* workspace_name)
{
    if (strcmp(workspace_name, "kitty") == 0)
        return "";

    if (strcmp(workspace_name, "firefox") == 0)
        return "󰈹";

    if (strcmp(workspace_name, "code") == 0)
        return "󰨞";

    return "";
}

int main()
{
    FILE *fp = popen("hyprctl clients -j", "r");

    if (!fp) {
        perror("popen");
        return 1;
    }

    char buffer[65536];

    size_t len =
        fread(buffer, 1, sizeof(buffer) - 1, fp);

    buffer[len] = '\0';

    pclose(fp);

    Workspace workspaces[32] = {0};

    json_object *root =
        json_tokener_parse(buffer);

    if (!root) {
        fprintf(stderr, "Failed to parse JSON\n");
        return 1;
    }

    int count =
        json_object_array_length(root);

    for (int i = 0; i < count; i++) {

        json_object *client =
            json_object_array_get_idx(root, i);

        json_object *class_obj;

        if (!json_object_object_get_ex(
                client,
                "class",
                &class_obj))
            continue;

        const char *class_name =
            json_object_get_string(class_obj);

        json_object *workspace_obj;

        if (!json_object_object_get_ex(
                client,
                "workspace",
                &workspace_obj))
            continue;

        json_object *id_obj;

        if (!json_object_object_get_ex(
                workspace_obj,
                "id",
                &id_obj))
            continue;

        int id =
            json_object_get_int(id_obj);

        if (id < 0 || id >= 32)
            continue;

        workspaces[id].id = id;
        workspaces[id].name = class_name;
        workspaces[id].icon =
            get_workspace_icon(class_name);
    }

    FILE *active_fp = popen("hyprctl activeworkspace -j", "r");

    if (!active_fp) {
        perror("popen 2");
        return 1;
    }

    len =
        fread(buffer, 1, sizeof(buffer) - 1, active_fp);

    buffer[len] = '\0';

    pclose(active_fp);

    json_object *active_root =
        json_tokener_parse(buffer);

    if (!active_root) {
        fprintf(stderr, "Failed to parse JSON\n");
        return 1;
    }

    json_object *active_id_obj;
    if (json_object_object_get_ex(
      active_root,
      "id",
      &active_id_obj)) {
      int active_id = json_object_get_int(active_id_obj);

      workspaces[active_id].active = 1;
    }

    char final_output[1024] = "";

    for (int i = 0; i < 32; i++) {

        if (workspaces[i].id == 0)
            continue;

        char temp[128];
        
        if(workspaces[i].active == 1) {
          snprintf(
              temp,
              sizeof(temp),
              "<span foreground=\\\"#89b4fa\\\">[%s %d]</span> ",
              workspaces[i].icon,
              workspaces[i].id
          );
          
          strcat(final_output, temp);
          continue;
        }

        snprintf(
            temp,
            sizeof(temp),
            "%s %d ",
            workspaces[i].icon,
            workspaces[i].id
        );

        strcat(final_output, temp);
    }

    printf(
        "{"
        "\"text\":\"%s\","
        "\"tooltip\":\"Custom Hyprland Workspaces\","
        "\"class\":\"workspacebar\""
        "}\n",
        final_output
    );

    json_object_put(root);

    return 0;
}
