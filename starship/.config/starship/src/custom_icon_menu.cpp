#include <fstream>
#include <iostream>
#include <string>
#include <unordered_map>

#include <toml++/toml.hpp>

int main() {
  std::unordered_map<int, std::string> ICONS_MAP = {{1, ""}, {2, ""}};

  toml::table config =
      toml::parse_file("/home/dmensxl/.config/starship/starship.toml");

  auto icon_line = config["custom"]["cicon"]["command"].value<std::string>();

  if (!icon_line) {
    std::cout << "no custom icon set!" << '\n';
    return 0;
  }

  std::string icon(1, icon_line->back());

  std::cout << "Hello to the changing theme for starship icon!" << '\n';
  std::cout << "Current icon: " << icon << '\n';
  std::cout << "Available icons: " << '\n';

  for (const auto &pair : ICONS_MAP) {
    std::cout << pair.first << ": " << pair.second << '\n';
  }

  std::cout << "Choose(0 leaves unchanged): ";

  int choice = 0;
  std::cin >> choice;

  if (choice == 0)
    return 0;

  std::string new_icon_line = "echo " + ICONS_MAP[choice];

  config["custom"]["cicon"].as_table()->insert_or_assign("command",
                                                         new_icon_line);

  std::ofstream out("/home/dmensxl/.config/starship/starship.toml");

  out << config;

  return 0;
}
