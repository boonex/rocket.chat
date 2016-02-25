Meteor.methods
	startImport: (name, input) ->
		# Takes name and object with users / channels selected to import
		if not Meteor.userId()
			throw new Meteor.Error 203, 'User_logged_out' #TODO: Update this to the new way of doing things

		if Importer.Importers[name]?.importerInstance?
			usersSelection = input.users.map (user) ->
				return new Importer.SelectionUser user.user_id, user.username, user.email, user.is_deleted, user.is_bot, user.do_import
			channelsSelection = input.channels.map (channel) ->
				return new Importer.SelectionChannel channel.channel_id, channel.name, channel.is_archived, channel.do_import

			selection = new Importer.Selection name, usersSelection, channelsSelection
			Importer.Importers[name].importerInstance.startImport selection
		else
			throw new Meteor.Error 'importer-not-defined', 'importer_not_defined_properly', { importerName: name }
