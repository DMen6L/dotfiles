#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/socket.h>
#include <sys/un.h>
#include <unistd.h>

typedef struct {
  int id;
  int active;
  int exists;

  char name[64];
  char icon[16];
} Workspace;

const char *get_workspace_icon(const char *workspace_name) {
  if (strcmp(workspace_name, "kitty") == 0)
    return "";

  if (strcmp(workspace_name, "firefox") == 0)
    return "󰈹";

  if (strcmp(workspace_name, "code") == 0)
    return "󰨞";

  if (strcmp(workspace_name, "nvim") == 0)
    return "";

  if (strcmp(workspace_name, "minecraft") == 0)
    return "󰍳";

  return "";
}

Workspace *get_workspace(Workspace workspaces[], int id) {
  if (id < 1 || id > 32)
    return NULL;

  return &workspaces[id];
}

/**
 * Switches active workspace.
 */
void set_active_workspace(Workspace **current, Workspace *next) {
  if (!next || !next->exists)
    return;

  if (*current)
    (*current)->active = 0;

  next->active = 1;
  *current = next;
}

void create_workspace(Workspace workspaces[], int id) {
  Workspace *ws = get_workspace(workspaces, id);

  if (!ws)
    return;

  ws->id = id;
  ws->exists = 1;
}

void destroy_workspace(Workspace workspaces[], int id) {
  Workspace *ws = get_workspace(workspaces, id);

  if (!ws)
    return;

  ws->id = 0;
  ws->exists = 0;
}

void open_window(Workspace workspaces[], int workspace_id,
                 const char *class_name) {
  Workspace *ws = get_workspace(workspaces, workspace_id);

  if (!ws || !ws->exists)
    return;

  strncpy(ws->name, class_name, sizeof(ws->name) - 1);

  strncpy(ws->icon, get_workspace_icon(class_name), sizeof(ws->icon) - 1);
}

void parse_open_window_event(Workspace workspaces[], char *args) {
  char *saveptr;

  char *address = strtok_r(args, ",", &saveptr);

  char *workspace = strtok_r(NULL, ",", &saveptr);

  char *class_name = strtok_r(NULL, ",", &saveptr);

  char *title = strtok_r(NULL, ",", &saveptr);

  (void)address;
  (void)title;

  if (!workspace || !class_name)
    return;

  int workspace_id = atoi(workspace);

  open_window(workspaces, workspace_id, class_name);
}

void render_workspaces(Workspace workspaces[]) {
  char bar_text[512] = "";
  char tmp[256];

  for (int i = 1; i <= 32; i++) {

    Workspace *ws = &workspaces[i];

    if (!ws->exists)
      continue;

    if (ws->active)
      snprintf(tmp, sizeof(tmp),
               "<span foreground='#89b4fa'>"
               "%s"
               "</span> ",
               ws->icon[0] ? ws->icon : "");
    else
      snprintf(tmp, sizeof(tmp), "%s ", ws->icon[0] ? ws->icon : "");

    strcat(bar_text, tmp);
  }

  char bar_json[1024];

  snprintf(bar_json, sizeof(bar_json), "{\"text\":\"%s\", \"markup\": true}",
           bar_text);

  printf("%s\n", bar_json);

  fflush(stdout);
}

void handle_event(Workspace workspaces[], Workspace **active_workspace,
                  char *line) {

  if (strncmp(line, "workspace>>", 11) == 0) {

    int id = atoi(line + 11);

    Workspace *ws = get_workspace(workspaces, id);

    set_active_workspace(active_workspace, ws);
    render_workspaces(workspaces);

    return;
  }

  if (strncmp(line, "createworkspace>>", 17) == 0) {

    int id = atoi(line + 17);

    create_workspace(workspaces, id);
    render_workspaces(workspaces);

    return;
  }

  if (strncmp(line, "destroyworkspace>>", 18) == 0) {

    int id = atoi(line + 18);

    destroy_workspace(workspaces, id);
    render_workspaces(workspaces);

    return;
  }

  if (strncmp(line, "openwindow>>", 12) == 0) {

    parse_open_window_event(workspaces, line + 12);
    render_workspaces(workspaces);

    return;
  }
}

int main() {
  int sock = socket(AF_UNIX, SOCK_STREAM, 0);

  if (sock < 0) {
    perror("socket");
    return 1;
  }

  const char *runtime = getenv("XDG_RUNTIME_DIR");

  const char *signature = getenv("HYPRLAND_INSTANCE_SIGNATURE");

  char path[512];

  snprintf(path, sizeof(path), "%s/hypr/%s/.socket2.sock", runtime, signature);

  struct sockaddr_un addr = {0};

  addr.sun_family = AF_UNIX;

  if (strlen(path) >= sizeof(addr.sun_path)) {
    fprintf(stderr, "Socket path too long\n");
    close(sock);
    return 1;
  }

  strcpy(addr.sun_path, path);

  if (connect(sock, (struct sockaddr *)&addr, sizeof(addr)) < 0) {
    perror("connect");
    close(sock);
    return 1;
  }

  Workspace workspaces[33] = {0};

  Workspace *active_workspace = NULL;

  char buffer[4096];

  // Simulate initial addition of first workspace
  handle_event(workspaces, &active_workspace, "createworkspace>>1");
  handle_event(workspaces, &active_workspace, "workspace>>1");

  while (1) {

    ssize_t n = read(sock, buffer, sizeof(buffer) - 1);

    if (n <= 0) {
      printf("Socket closed\n");
      break;
    }

    buffer[n] = '\0';

    char *saveptr;

    char *line = strtok_r(buffer, "\n", &saveptr);

    while (line) {

      handle_event(workspaces, &active_workspace, line);

      line = strtok_r(NULL, "\n", &saveptr);
    }
  }

  close(sock);

  return 0;
}
