# Menu Image Mapping

Source review date: 2026-05-06

Menu source used: `C:\Users\edward\projects\juicy_dumplings_site_docs\menu.png`

Dish photo source used: `C:\Users\edward\projects\juicy_dumplings_site_docs\photos`

No internet-sourced food photos were used in this phase. Images are local-first seed assets for Active Storage.

## Extracted Menu

| Category | Item name | Description if visible | Price | Confidence | Source image |
| --- | --- | --- | --- | --- | --- |
| A La Carte | Wuxi Juicy Dumpling | 4 pcs/basket | $6.80 | High | menu.png |
| A La Carte | Shanghai Juicy Dumpling | 4 pcs/basket | $6.80 | High | menu.png |
| A La Carte | Mini Pork Wonton | 25 pcs/bowl; choose clear soup/red soup/dry mixed | $12.80 | High | menu.png |
| A La Carte | Shepherd's Purse & Pork Jumbo Wonton | 8 pcs/bowl; choose clear soup/red soup/dry mixed | $12.80 | High | menu.png |
| A La Carte | Prawn, Vege & Pork Jumbo Wonton | 8 pcs/bowl; choose clear soup/red soup/dry mixed | $13.80 | High | menu.png |
| A La Carte | Dried Shrimp & Pork Wonton | 10 pcs/bowl | $13.80 | High | menu.png |
| Set Meals | Set A: Wuxi Juicy Dumpling + Mini Pork Wonton + Tea Egg | Combo | $20.00 | High | menu.png |
| Set Meals | Set B: Shanghai Juicy Dumpling + Mini Pork Wonton + Tea Egg | Combo | $20.00 | High | menu.png |
| Set Meals | Set C: Shepherd's Purse & Pork Jumbo Wonton + Tea Egg | Soup/dry + tea egg | $13.80 | High | menu.png |
| Set Meals | Set D: Prawn, Vege & Pork Jumbo Wonton + Tea Egg | Soup/dry + tea egg | $14.80 | High | menu.png |
| Set Meals | Set E: Wuxi Juicy Dumpling + Dried Shrimp & Pork Wonton | Soup/dry | $18.80 | High | menu.png |
| Set Meals | Set F: Chongming Rice Cake + Mini Pork Wonton + Tea Egg | Combo | $23.80 | High | menu.png |
| Sides | Tea Egg | English item visible | $2.50 | High | menu.png |
| Sides | Spring Rolls | 2 pcs | $5.00 | High | menu.png |
| Sides | Chongming Rice Cake | Item visible | $11.50 | High | menu.png |
| Pan-Fried Wontons | Pan-Fried Shepherd's Purse & Pork Jumbo Wonton | Item visible | $14.80 | High | menu.png |
| Pan-Fried Wontons | Pan-Fried Prawn, Vege & Pork Jumbo Wonton | Item visible | $15.80 | High | menu.png |
| Drinks | Soft Drink / Wang Lao Ji | Item visible | $3.00 | High | menu.png |
| Drinks | Soy Milk | Item visible | $4.50 | High | menu.png |

## Final Image Mapping

| Seed asset | Source photo | Proposed menu item(s) | Confidence | Reason | Decision |
| --- | --- | --- | --- | --- | --- |
| `wuxi_juicy_dumpling.jpg` | dish1.png | Wuxi Juicy Dumpling; Set A | High | Four steamed soup dumplings in a bamboo steamer. | Kept local |
| `shanghai_juicy_dumpling.jpg` | dish1.png | Shanghai Juicy Dumpling; Set B | Medium | Same dish family as Wuxi; no separate Shanghai photo available. | Kept local |
| `mini_pork_wonton.jpg` | dish4.png | Mini Pork Wonton | Medium | Wonton soup bowl with many smaller wontons. | Kept local |
| `shepherds_purse_pork_jumbo_wonton.jpg` | dish7.png | Shepherd's Purse & Pork Jumbo Wonton; Set C | Medium | Clear soup jumbo wonton bowl; closest local match. | Kept local |
| `prawn_vege_pork_jumbo_wonton.jpg` | dish7.png | Prawn, Vege & Pork Jumbo Wonton; Set D | Medium | Clear soup jumbo wonton bowl; closest local match. | Kept local |
| `dried_shrimp_pork_wonton.jpg` | dish5.png | Dried Shrimp & Pork Wonton; Set E | High | Visible dried shrimp/seaweed garnish in soup. | Kept local |
| `tea_egg.jpg` | dish2.png | Tea Egg | High | Direct tea egg photo. | Kept local |
| `spring_rolls.jpg` | dish6.png | Spring Rolls | High | Cleaner spring roll photo than the previous dish3 crop. | Replaced with better local |
| `chongming_rice_cake.jpg` | menu.png crop | Chongming Rice Cake; Set F | Medium | Only available local visual for rice cake. | Local menu crop |
| `pan_fried_jumbo_wonton.jpg` | menu.png crop | Pan-Fried Wonton items | Medium | Only available local visual for pan-fried wontons. | Local menu crop |
| `soft_drink_wang_lao_ji.jpg` | menu.png crop | Soft Drink / Wang Lao Ji | Medium | Shows listed drink options from the menu board. | Local menu crop |
| `soy_milk.jpg` | menu.png crop | Soy Milk | Medium | Shows soy milk carton from the menu board. | Local menu crop |

## Follow-Up Image Needs

Better original photos would still improve:

- Chongming Rice Cake
- Pan-Fried Shepherd's Purse & Pork Jumbo Wonton
- Pan-Fried Prawn, Vege & Pork Jumbo Wonton
- Soft Drink / Wang Lao Ji
- Soy Milk
