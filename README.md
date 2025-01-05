# praat
praat 스크립트 저장소 <br> <br>

원하는 praat 스크립트를 찾기 힘들어서 써봤습니다. <br>
지극히 저의 편의를 위한 아카이브용 레포지토리여서 설명이나 기능이 불친절할 수도 있습니다. <br>
앞으로 스크립트를 쓸 일이 있다면 계속 추가될...지도...? <br>

## 파일 설명
### get_intensity_from_point.praat
선택한 지점의 intensity를 구하는 스크립트입니다. <br>
구하고자 하는 지점들이 음성 파일과 동일한 이름을 가진 textgrid에 point tier로 라벨링 되어 있을 것을 전제로 하고 있습니다.

### fricative_spectral_analysis.praat
[Shadle(2023)](https://doi.org/10.1121/10.0017231)에서 제안된 파라미터 중 Fm, Am, Fmin, Amin, Ad를 계산하기 위한 스크립트입니다. <br>
이 스크립트에서는 mid-band를 4000-10000Hz로 가정하고 있습니다. 사용하시려는 데이터에 맞게 수정해주세요.
