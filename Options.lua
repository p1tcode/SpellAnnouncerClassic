local options = {
	name = "SpellAnnouncerClassic",
	handler = SAC,
	tupe = 'group',
	args = {
		msg = {
			type = 'input',
			name = 'Message',
			desc = 'Dette er en melding for min addon',
			set = 'SetFunction',
			get = 'GetFunction',
		},
	},
}