# Use to manage the player's inventory.
import ItemManager

# Use to get player's information.
import BasePlayer

class spawnitemsv2:

	def __init__(self):
		self.Title = "Startup Items Revamp"
		self.Author = "Roy (Christian Deacon) and RedNinja1337"
		self.Version = V(0,1,0)
		self.Description = "Chooses start up items."
		
	def LoadDefaultConfig(self):
		self.Config['GroupItems'] = ({
			'supporter':
			(
				{'item_shortname':'attire.hide.boots', 'Amount':1, 'Container':'Wear'},
				{'item_shortname':'attire.hide.pants', 'Amount':1, 'Container':'Wear'},
				{'item_shortname':'rock', 'Amount':1, 'Container':'Belt'},
				{'item_shortname':'arrow.hv', 'Amount':25, 'Container':'Main'},
			),
			 
			'default':
			(
				{'item_shortname':'bow.hunting', 'Amount':1, 'Container':'Belt'},
				{'item_shortname':'rifle.bolt', 'Amount':25, 'Container':'Main'},
			),

			'player':
			(
				{},
			)
		})
	
	def OnPlayerRespawned(self, BasePlayer):
		if self.Config['GroupItems']:
			Groups = self.Config['GroupItems']
			
			inv = BasePlayer.inventory
			inv.Strip()
			
			for group in Groups:
				if permission.UserHasGroup(str(BasePlayer.userID), group):
					items = self.Config['GroupItems'][group]

					for item in items:
						try:
							if item['Container'] and item['Amount'] and item['item_shortname']:
								# Add the items set on the configuration file to each container on the player's inventory.
								if item['Container'].lower() == 'main':
									inv.GiveItem(ItemManager.CreateByName(item['item_shortname'],item['Amount']), inv.containerMain)
								elif item['Container'].lower() == 'belt':
									inv.GiveItem(ItemManager.CreateByName(item['item_shortname'],item['Amount']), inv.containerBelt)
								elif item['Container'].lower() == 'wear':
									inv.GiveItem(ItemManager.CreateByName(item['item_shortname'],item['Amount']), inv.containerWear)
						except KeyError: print