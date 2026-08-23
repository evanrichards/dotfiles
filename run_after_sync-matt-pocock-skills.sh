#!/bin/bash

set -euo pipefail

skill_root="${HOME}/.claude/plugins/marketplaces/mattpocock/skills"
agent_skill_root="${HOME}/.agents/skills"

if [[ ! -d "${skill_root}" ]]; then
  echo "Skip Matt Pocock skill links. The Claude marketplace is not installed."
  exit 0
fi

mkdir -p "${agent_skill_root}"

# Remove only stale links that this script created.
while IFS= read -r -d '' link_path; do
  link_target="$(readlink "${link_path}")"
  if [[ "${link_target}" == "${skill_root}/"* && ! -f "${link_target}/SKILL.md" ]]; then
    rm "${link_path}"
  fi
done < <(find "${agent_skill_root}" -mindepth 1 -maxdepth 1 -type l -print0)

while IFS= read -r -d '' skill_file; do
  skill_dir="$(dirname "${skill_file}")"
  skill_name="$(basename "${skill_dir}")"
  link_path="${agent_skill_root}/${skill_name}"

  if [[ -L "${link_path}" ]]; then
    link_target="$(readlink "${link_path}")"
    if [[ "${link_target}" == "${skill_dir}" ]]; then
      continue
    fi
    if [[ "${link_target}" == "${skill_root}/"* ]]; then
      ln -sfn "${skill_dir}" "${link_path}"
      continue
    fi
  fi

  if [[ -e "${link_path}" || -L "${link_path}" ]]; then
    echo "Skip ${skill_name}. The target path already exists."
    continue
  fi

  ln -s "${skill_dir}" "${link_path}"
done < <(find "${skill_root}" -type f -name SKILL.md -print0)
