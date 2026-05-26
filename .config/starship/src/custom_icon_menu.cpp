#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <vector>

#include <toml++/toml.hpp>

std::vector<std::string> split(const std::string &text, char delim) {
  std::stringstream ss(text);

  std::vector<std::string> parts;
  std::string item;

  while (std::getline(ss, item, delim)) {
    parts.push_back(item);
  }

  return parts;
}

struct CustomIcon {
  std::string sec_name;
  std::string bg;
  std::string fg;
};

int main() {

  std::vector<CustomIcon> custom_icons;

  // Parsin toml file
  auto config =
      toml::parse_file("/home/dmensxl/.config/starship/starship.toml");

  // Getting all customs
  auto *customs = config["custom"].as_table();

  int i = 0;
  std::cout << "Choice list: " << '\n';

  for (auto &&[key, val] : *customs) {
    std::string sec_name{key.str()};
    std::string bg;
    std::string fg;

    std::string curr_icon;

    auto *sec = val.as_table();

    if (sec) {
      auto bg_fg = (*sec)["style"].value<std::string>();

      if (bg_fg) {
        for (std::string part : split(*bg_fg, ' ')) {
          std::vector<std::string> style_parts = split(part, ':');

          if (style_parts.size() != 2)
            std::cerr << "configuration of syle is wroing" << '\n';

          if (style_parts[0] == "bg")
            bg = style_parts[1];
          else
            fg = style_parts[1];
        }
      }

      auto command = (*sec)["command"].value<std::string>();

      if (command) {
        curr_icon = split(*command, ' ')[1];
      }
    }

    custom_icons.push_back({sec_name, bg, fg});

    std::cout << i << ". " << sec_name << " " << curr_icon << '\n';
    i++;
  }
  int choice;
  std::cout << "Choose new theme(-1 to skip): ";
  std::cin >> choice;

  if (choice < 0 || choice >= custom_icons.size())
    return 0;

  CustomIcon new_sec = custom_icons[choice];

  std::string new_format = "[](base)$os$username"
                           "[](bg:peach fg:base)$directory"
                           "[](bg:yellow fg:peach)$git_branch$git_status"
                           "[](fg:yellow bg:" +
                           new_sec.bg +
                           ")"
                           "${custom." +
                           new_sec.sec_name +
                           "}"
                           "[ ](fg:" +
                           new_sec.bg +
                           ")"
                           "\n$character";

  config.insert_or_assign("format", new_format);

  std::ofstream out("/home/dmensxl/.config/starship/starship.toml");
  out << config;

  return 0;
}
