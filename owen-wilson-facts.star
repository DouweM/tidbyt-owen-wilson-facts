load("http.star", "http")
load("xpath.star", "xpath")
load("render.star", "render")
# https://github.com/DouweM/tap-pixlet/blob/main/tap_pixlet/pixlib/const.star
load("pixlib/const.star", "const")

URL = "https://www.owenwilsonfactory.com/facts?format=rss"

def main(config):
  response = http.get(URL)

  if response.status_code != 200:
    fail("Failed to load Owen Wilson FACTory feed")

  data = response.body()
  doc = xpath.loads(data)
  item = doc.query_node("//item")

  title = item.query("/title")

  description_data = item.query("/description")
  description_doc = xpath.loads(description_data)
  description = description_doc.query("/p")

  text_height = 5
  header_height = text_height + 2
  fact_height = const.HEIGHT - header_height

  return render.Root(
    render.Column(
      expanded=True,
      children=[
        render.Box(
          height=header_height,
          color="#ffc700",
          child=render.Padding(
            pad=(1,0,0,0),
            child=render.Text("Owen Wilson Fact", font="CG-pixel-3x5-mono", color="#000")
          )
        ),
        render.Marquee(
          scroll_direction="vertical",
          offset_start=fact_height,
          height=fact_height,
          width=const.WIDTH,
          child=render.Column(
            children=[
              render.Text(title + ":"),
              render.WrappedText(description),
              render.Padding(
                pad=(0,8,0,0),
                child=render.Text("WOW")
              )
            ]
          )
        )
      ]
    )
  )
