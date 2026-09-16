import Quickshell

Scope {
    WorkspaceController {
        id: workspaceController
    }

    StatusData {
        id: statusData
    }

    OrnamentalStrip {}

    MainPanel {
        workspaceController: workspaceController
        statusData: statusData
    }
}
