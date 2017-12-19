require 'squib'
require 'game_icons'

data      = Squib.xlsx file: 'last-stand.xlsx'
counts = data['Count']

icon_names = ['arrow-scope', 'gunshot', 'honeycomb', 'beams-aura', 'ice-cube', 'on-sight']
icons_data = {}; data['Name'].zip(data['Target'], data['Attack'], data['Effect'], data['Ability'], data['NoFreeze'], data['NoIronsight']).each {|values| values[1..6].each_with_index{|b, i| if b then (icons_data[values[0]] ||= []) << icon_names[i] end}}

data = data.each{|name, values| data[name] = values.zip(counts).map{|index, count| [index]*count.to_i}.flatten}
num_cards = data['Name'].size

types = ['Character', 'Offense', 'Defense', 'Sabotage', 'Chaos']
type_icons = {'Character' => 'sensuousness', 'Offense' => 'bullets', 'Defense' => 'shield', 'Sabotage' => 'fizzing-flask', 'Chaos' => 'rolling-bomb'}

#Squib::Deck.new(cards: num_cards, layout: 'layout.yml') do
Squib::Deck.new(cards: num_cards, layout: 'layout.yml', width: '2.5in', height: '3.5in') do
  background color: 'white'

  type = {}; data['Type'].each_with_index{ |t, i| (type[t] ||= []) << i}
  types.each do |t|
    background layout: 'bg_' + t, range: type[t]
    rect layout: 'name_rect_' + t, range: type[t]
    svg layout: :type_icon, data: GameIcons.get(type_icons[t]).recolor(fg: '#000', bg_opacity: "0.0").string, width: '0.5in', height: '0.5in', angle: -Math::PI / 2, range: type[t]
  end
    
  text layout: :name_text, str: data['Name'], angle: -Math::PI / 2#, hint: :red
    
  text layout: :desc_text, str: data['Description']do |embed|
    embed.svg key: ':heart:', file: 'heart.svg', width: 50, height: 50
  end
  text layout: :use_text, str: data['Activation']
  
  names_for_icons = {}; data['Name'].each_with_index{ |t, i| (names_for_icons[t] ||= []) << i}
  icons_data.each do |name, icons|
    case icons.length
    when 1
      svg layout: :icon_slot_3, data: GameIcons.get(icons[0]).recolor(fg: '#000', bg_opacity: "0.0").string, range: names_for_icons[name]
    when 2
      svg layout: :icon_slot_2, data: GameIcons.get(icons[0]).recolor(fg: '#000', bg_opacity: "0.0").string, range: names_for_icons[name]
      svg layout: :icon_slot_4, data: GameIcons.get(icons[1]).recolor(fg: '#000', bg_opacity: "0.0").string, range: names_for_icons[name]
    when 3
      svg layout: :icon_slot_1, data: GameIcons.get(icons[0]).recolor(fg: '#000', bg_opacity: "0.0").string, range: names_for_icons[name]
      svg layout: :icon_slot_3, data: GameIcons.get(icons[1]).recolor(fg: '#000', bg_opacity: "0.0").string, range: names_for_icons[name]
      svg layout: :icon_slot_5, data: GameIcons.get(icons[2]).recolor(fg: '#000', bg_opacity: "0.0").string, range: names_for_icons[name]
    end
  end
  
  #rect layout: :cut
  #rect layout: :safe
  save_sheet prefix: 'last_stand_sheet_', columns: 10, rows: 7
  #save_png prefix: 'card_', range: 54
end