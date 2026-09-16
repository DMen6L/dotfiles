import QtQml
import Quickshell.Hyprland

QtObject {
    property var workspaceIds: [1, 2, 3]
    readonly property int focusedWorkspaceId: Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 0

    function workspaceById(workspaceId) {
        if (!Hyprland.workspaces || !Hyprland.workspaces.values)
            return null;

        const workspace = Hyprland.workspaces.values.find(function (candidate) {
            return candidate.id === workspaceId;
        });

        return workspace === undefined ? null : workspace;
    }

    function activateWorkspace(workspaceId) {
        const workspace = workspaceById(workspaceId);

        if (workspace) {
            workspace.activate();
        } else if (Hyprland.usingLua) {
            Hyprland.dispatch("hl.dsp.focus({ workspace = " + workspaceId + " })");
        } else {
            Hyprland.dispatch("workspace " + workspaceId);
        }
    }
}
