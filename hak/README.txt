If you want to build, you will need to assemble the haks as follows using the nwhak tool.
anemoi_2da_0.2.hak - contents of the Override folder (the 2da hak folder will also work, mostly, but is out of date and not maintained).
anemoi_creatures.hak - contents of the anemoi_creatures folder
anemoi_tiles.hak - contents of the anemoi_tiles hak
crprural.hak - contents of the crprural folder
tm-clothes-v1b-f.hak - contents of the tm-clothes-v1b-f folder
tm-clothes-v1b-o.hak - contents of the tm-clothes-v1b-o folder

You should put these haks in your hak folder and cow.tlk in your tlk folder.  You can ignore the other folders (comp-tiles etc). 

There is a builders' mod zipped in the utils folder. This has out of date scripts - if you want the latest you'll need to copy them in from the scripts folder - but I don't recommend you try and compile scripts yourself unless you're using an external compiler.  The engine is huge and the toolset compiler has had problems with it in the past.

Building FAQ:
- All areas should have the a_enter script in OnEnter and a_exit in OnExit
- Please don't add any new scripts unless you are certain no script already exists that does what you want.
- Encounters - you can use NWN encounters but for most purposes we use Gigaschatten ones, which are set up DM side - so just say what creatures you want to spawn where.  Bosses have to be done in game. 
