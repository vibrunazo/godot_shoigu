extends PanelContainer

var credits: = """
source: [url=https://github.com/vibrunazo/godot_shoigu]github.com/vibrunazo/godot_shoigu[/url]
play at: [url=https://vib.itch.io/shoigu]vib.itch.io/shoigu[/url]

Developed by:
	vibrunazo

Special thanks to:
	Awesomesauce1337
	Winter-Revolution-41
	ApokalypseCow
	[url=https://www.reddit.com/r/NonCredibleDefense/comments/16ig0mt/shoigu_shrug_reaction_gif/]r/noncredibledefense[/url]

Assets:
	[url=https://opengameart.org/content/punch]qubodup[/url]
	[url=https://kenney.nl]Kenney[/url]

[url=https://godotengine.org/]Godot Game Engine[/url]
"""

func _ready():
	%CreditsLabel.text = credits

func _on_credits_label_meta_clicked(meta):
	print('meta clicked %s' % meta)
	
	OS.shell_open(meta)


func _on_visibility_changed():
	if is_visible_in_tree():
		%BackButton.grab_focus()
