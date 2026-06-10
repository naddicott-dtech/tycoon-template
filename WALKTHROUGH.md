# WALKTHROUGH — your first hour with the Tycoon template

Work through this **at your own pace**, top to bottom, checking boxes as you go.
Nobody is timing you. If you get stuck, the `README.md` has the full reference
(especially the **"Where every knob lives"** table) — this page just tells you
what to do next.

> **Save ritual (web editor):** every 10–15 minutes, **Project > Tools >
> Download Project Source**. The browser can forget your work; downloads don't.

---

## Part 1 — Play it (5 minutes)

- [ ] Press **Play** (the ▶ button, top right).
- [ ] Read the mission text, then click **Dismiss** until it's gone.
- [ ] Click **End Day** a few times. Watch the money go up.
- [ ] **Buy** a stand. **Upgrade** your stands. Keep ending days until the game
      tells you that you lost.

You lost. That's not you — **the game ships with impossible numbers.**

## Part 2 — Watch it fail (10 minutes)

Prove the game is rigged. On paper or in a spreadsheet:

- [ ] Write down: your starting money, what one stand earns per day, the price
      of a stand, the goal, and the deadline. (Play again and read the screen,
      or peek at the README's knob table to see where each number lives.)
- [ ] Figure out the *best case*: if you spent perfectly, what's the most money
      you could have by the deadline?
- [ ] Compare that to the goal. Convinced?

That gap is the game design job. Everything you do from here is about making
the game *possible but not easy*.

## Part 3 — Make it yours (the rest of the hour)

**Theme it** — decide what your shop sells.

- [ ] Open `scenes/levels/Level1.tscn`. Click the `Stand` under `Entities`.
- [ ] In the Inspector, change **Item Name** from "Consumable Item A" to your
      real product.
- [ ] Open `UI/Message` (it's in `Main.tscn`) and rewrite the mission text in
      your own words.

**Build your shop.**

- [ ] Click your stand, press **Ctrl+D** to duplicate it, drag the copy
      somewhere sensible. Repeat until your shop looks like a shop.
- [ ] Give each stand its own **Item Name**. Maybe one is a higher **Tier**?
- [ ] Press Play. The **Buy** button copies your **top** stand — check that a
      bought stand matches your theme.

**Art pass** (do as much as you want now, more later).

- [ ] Replace at least one placeholder picture: click a stand, and in the
      Inspector drop a real image into **Level 1 Texture**. (The `assets/`
      folder shows what's there now.)

**Balance pass — the real design work.**

- [ ] Decide your numbers: starting money, stand income, prices, goal, deadline.
      Use your Part 2 math: make winning *possible* first.
- [ ] Change them (the README table says exactly where each one lives).
- [ ] Play a full run. Too easy? Too brutal? Nudge and replay. Two or three
      rounds of this is normal — that's what game designers do all day.
- [ ] Optional: turn on rent. Set **Upkeep Per Stand** on the `Level1` root to
      a small number and feel how the game tightens.

## Part 4 — Before you show anyone

- [ ] Run the **playtest checklist** at the bottom of `README.md`.
- [ ] Save: **Project > Tools > Download Project Source.**

## Want more?

When the no-code knobs stop being enough, open **`CHALLENGES.md`** — small,
ordered coding tasks that change how the game *works*, starting tiny.
