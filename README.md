furniture

Chairs, stools, and tables.

License for all of this mod is "CC0", see below.

```txt
CREATIVE COMMONS CORPORATION IS NOT A LAW FIRM AND DOES NOT PROVIDE LEGAL SERVICES. DISTRIBUTION OF THIS DOCUMENT DOES NOT CREATE AN ATTORNEY-CLIENT RELATIONSHIP. CREATIVE COMMONS PROVIDES THIS INFORMATION ON AN "AS-IS" BASIS. CREATIVE COMMONS MAKES NO WARRANTIES REGARDING THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS PROVIDED HEREUNDER, AND DISCLAIMS LIABILITY FOR DAMAGES RESULTING FROM THE USE OF THIS DOCUMENT OR THE INFORMATION OR WORKS PROVIDED HEREUNDER.

Statement of Purpose
The laws of most jurisdictions throughout the world automatically confer exclusive Copyright and Related Rights (defined below) upon the creator and subsequent owner(s) (each and all, an "owner") of an original work of authorship and/or a database (each, a "Work").
Certain owners wish to permanently relinquish those rights to a Work for the purpose of contributing to a commons of creative, cultural and scientific works ("Commons") that the public can reliably and without fear of later claims of infringement build upon, modify, incorporate in other works, reuse and redistribute as freely as possible in any form whatsoever and for any purposes, including without limitation commercial purposes. These owners may contribute to the Commons to promote the ideal of a free culture and the further production of creative, cultural and scientific works, or to gain reputation or greater distribution for their Work in part through the use and efforts of others.
For these and/or other purposes and motivations, and without any expectation of additional consideration or compensation, the person associating CC0 with a Work (the "Affirmer"), to the extent that he or she is an owner of Copyright and Related Rights in the Work, voluntarily elects to apply CC0 to the Work and publicly distribute the Work under its terms, with knowledge of his or her Copyright and Related Rights in the Work and the meaning and intended legal effect of CC0 on those rights.

1. Copyright and Related Rights. A Work made available under CC0 may be protected by copyright and related or neighboring rights ("Copyright and Related Rights"). Copyright and Related Rights include, but are not limited to, the following:
	i.	the right to reproduce, adapt, distribute, perform, display, communicate, and translate a Work;
	ii.	moral rights retained by the original author(s) and/or performer(s);
	iii.	publicity and privacy rights pertaining to a person's image or likeness depicted in a Work;
	iv.	rights protecting against unfair competition in regards to a Work, subject to the limitations in paragraph 4(a), below;
	v.	rights protecting the extraction, dissemination, use and reuse of data in a Work;
	vi.	database rights (such as those arising under Directive 96/9/EC of the European Parliament and of the Council of 11 March 1996 on the legal protection of databases, and under any national implementation thereof, including any amended or successor version of such directive); and
	vii.	other similar, equivalent or corresponding rights throughout the world based on applicable law or treaty, and any national implementations thereof.

2. Waiver. To the greatest extent permitted by, but not in contravention of, applicable law, Affirmer hereby overtly, fully, permanently, irrevocably and unconditionally waives, abandons, and surrenders all of Affirmer's Copyright and Related Rights and associated claims and causes of action, whether now known or unknown (including existing as well as future claims and causes of action), in the Work (i) in all territories worldwide, (ii) for the maximum duration provided by applicable law or treaty (including future time extensions), (iii) in any current or future medium and for any number of copies, and (iv) for any purpose whatsoever, including without limitation commercial, advertising or promotional purposes (the "Waiver"). Affirmer makes the Waiver for the benefit of each member of the public at large and to the detriment of Affirmer's heirs and successors, fully intending that such Waiver shall not be subject to revocation, rescission, cancellation, termination, or any other legal or equitable action to disrupt the quiet enjoyment of the Work by the public as contemplated by Affirmer's express Statement of Purpose.

3. Public License Fallback. Should any part of the Waiver for any reason be judged legally invalid or ineffective under applicable law, then the Waiver shall be preserved to the maximum extent permitted taking into account Affirmer's express Statement of Purpose. In addition, to the extent the Waiver is so judged Affirmer hereby grants to each affected person a royalty-free, non transferable, non sublicensable, non exclusive, irrevocable and unconditional license to exercise Affirmer's Copyright and Related Rights in the Work (i) in all territories worldwide, (ii) for the maximum duration provided by applicable law or treaty (including future time extensions), (iii) in any current or future medium and for any number of copies, and (iv) for any purpose whatsoever, including without limitation commercial, advertising or promotional purposes (the "License"). The License shall be deemed effective as of the date CC0 was applied by Affirmer to the Work. Should any part of the License for any reason be judged legally invalid or ineffective under applicable law, such partial invalidity or ineffectiveness shall not invalidate the remainder of the License, and in such case Affirmer hereby affirms that he or she will not (i) exercise any of his or her remaining Copyright and Related Rights in the Work or (ii) assert any associated claims and causes of action with respect to the Work, in either case contrary to Affirmer's express Statement of Purpose.

4. Limitations and Disclaimers.
	a.	No trademark or patent rights held by Affirmer are waived, abandoned, surrendered, licensed or otherwise affected by this document.
	b.	Affirmer offers the Work as-is and makes no representations or warranties of any kind concerning the Work, express, implied, statutory or otherwise, including without limitation warranties of title, merchantability, fitness for a particular purpose, non infringement, or the absence of latent or other defects, accuracy, or the present or absence of errors, whether or not discoverable, all to the greatest extent permissible under applicable law.
	c.	Affirmer disclaims responsibility for clearing rights of other persons that may apply to the Work or any use thereof, including without limitation any person's Copyright and Related Rights in the Work. Further, Affirmer disclaims responsibility for obtaining any necessary consents, permissions or other rights required for any use of the Work.
	d.	Affirmer understands and acknowledges that Creative Commons is not a party to this document and has no duty or obligation with respect to this CC0 or use of the Work.
```

Mod api:

```lua
furniture.register_chair("recipe:node", {item definition})
furniture.register_stool("recipe:node", {item definition})
furniture.register_bench("recipe:node", {item definition})
furniture.register_table("recipe:node", {item definition})
furniture.register_stump("recipe:node", {item definition})
furniture.register_pedestal("recipe:node", {item definition})
furniture.register_couch("recipe:node", {item definition})
```

```lua
item_definition = {
	prefix = "furniture:", -- Default is the name of your mod, not "furniture:". Can have more after the mod name.
			-- Do not use ":" at beginning. Can be mods other than your own.
	description = "Wooden", -- Default copied from "recipe:node" with added furniture type at end.
	tiles = {"default_wood.png"}, -- Default copied from "recipe:node". Some furniture types have modified defaults.
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3}, -- Default copied from "recipe:node" with tweaks.
	connects_to = {"group:fence"} -- Only used for tables and pedestals. Default for table = {"group:fence"}. Default for pedestal = {"group:wall"}.
	sounds = default.node_sound_wood_defaults(), -- Default copied from "recipe:node".
	stick = "group:stick", -- Used for crafting. Default "group:stick". Default for stumps is "recipe:node". Not used for tables and pedestals.
	handle_crafts = true -- Should craft recipes be automatically made. nil = true
}
```

To use the sit function separately use...

```lua
furniture.register_seat("mymods:chair")
```

Legacy api:

Registers nodes in active mod with new api, configurable with prefix. After updating use...

```lua
minetest.register_alias("furniture:chair_wood", prefix.."chair_wood")
-- Benches have 4 nodes.
minetest.register_alias("furniture:bench_wood", prefix.."bench_wood")
minetest.register_alias("furniture:bench_middle_wood", prefix.."bench_middle_wood")
minetest.register_alias("furniture:bench_left_wood", prefix.."bench_left_wood")
minetest.register_alias("furniture:bench_right_wood", prefix.."bench_right_wood")
```

Stone and wool stools were changed to stumps.

```lua
minetest.register_alias("furniture:stool_cobble", prefix.."stump_cobble")
-- Need a second one for the prefix change.
minetest.register_alias("furniture:stump_cobble", prefix.."stump_cobble")
```

Stone tables were changed to pedestals.

```lua
minetest.register_alias("furniture:table_cobble", prefix.."pedestal_cobble")

minetest.register_alias("furniture:pedestal_cobble", prefix.."pedestal_cobble")
```

Wool chairs were changed to couches.

```lua
minetest.register_alias("furniture:chair_wool", prefix.."couch_wool")
minetest.register_alias("furniture:chair_middle_wool", prefix.."couch_middle_wool")
minetest.register_alias("furniture:chair_left_wool", prefix.."couch_left_wool")
minetest.register_alias("furniture:chair_right_wool", prefix.."couch_right_wool")

minetest.register_alias("furniture:couch_wool", prefix.."couch_wool")
minetest.register_alias("furniture:couch_middle_wool", prefix.."couch_middle_wool")
minetest.register_alias("furniture:couch_left_wool", prefix.."couch_left_wool")
minetest.register_alias("furniture:couch_right_wool", prefix.."couch_right_wool")
```

Old reference api:

```lua
furniture.register_wooden("recipe:node", {item definition})
furniture.register_stone("recipe:node", {item definition})
furniture.register_wool("recipe:node", {item definition})
```

```lua
furniture.register_wooden("default:wood", {
	description = "Wooden",
	description_chair = "Wooden Chair", -- Not used in "furniture.register_stone".
	description_stool = "Wooden Stool",
	description_bench = "Wooden Bench", -- Only used in "furniture.register_wooden".
	description_table = "Wooden Table", -- Not used in "furniture.register_wool".
	tiles = {"default_wood.png"},
	tiles_chair = {"default_wood.png"}, -- Only used in "furniture.register_wooden".
	tiles_table = {"default_wood.png"}, -- Only used in "furniture.register_wooden".
	groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3},
	sounds = default.node_sound_wood_defaults(),
	stick = "group:stick", -- Used for crafting. Not used in "furniture.register_stone".
	handle_crafts = true -- Should craft recipes be automatically made. nil = true
})
```
