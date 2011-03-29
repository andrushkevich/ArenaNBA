class TeamMetaInfo < MetaInfo
  
  def prepare_template(team, template, lang)
    template = template.gsub("$TAN", team.current_abbreviation(lang)).gsub("$TN", team.current_name(lang))
    template = template.gsub("$TD", team.team_division.name).gsub("$TT", team.team_type.name)
    template
  end
  
end