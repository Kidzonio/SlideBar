# How to create a SlideBar?

```lua
createSlideBar('Identificator',
BackGroundPositionX,
BackGroundPositionY,
BackGroundWidth,
BackGroundHeight,
CircleWidth,
CircleHeight,
{
    backGround = tocolor(R, G, B, A),
    circle = tocolor(R, G, B, A)
}
)
```


![Preview](https://github.com/Kidzonio/SlideBar/blob/main/slidebar.png)

# SlideBar Functions

* #### Delete a SlideBar

```lua
deleteSlideBar('Identificator');
```

* #### Delete all SlideBars

```lua
deleteAllSlideBars('Identificator');
```

* #### Get all SlideBars

```lua
getAllSlideBars();
```

* #### Get SlideBar Progress

```lua
getSlideBarProgress('Identificator'); -- Returns a integer value between 1 and 100
```

* #### Block a SlideBar

```lua
setSlideBarBlocked('Identificator', state) -- If done this way, the SlideBar will receive the value passed.

-- or

setSlideBarBlocked('Identificator') -- If done this way, the SlideBar will receive the opposite value to what it was before.
```

* #### Show a SlideBar

```lua
setSlideBarShowing('Identificator', state) -- If done this way, the SlideBar will receive the value passed.

-- or

setSlideBarShowing('Identificator') -- If done this way, the SlideBar will receive the opposite value to what it was before.
```