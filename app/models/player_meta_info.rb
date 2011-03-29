class PlayerMetaInfo < MetaInfo
  
  def prepare_template(player, template, lang)
    template = template.gsub("$PFN",player.current_first_name(lang)).gsub("$PLN", player.current_last_name(lang) )
    template = template.gsub("$PT", player.team.current_name(lang))
    template
  end
  
end