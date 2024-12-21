const places = [
  {
    name: "Taj Mahal",
    description: "The Taj Mahal is an ivory-white marble mausoleum on the south bank of the Yamuna river in the Indian city of Agra.",
    imageUrl: "https://example.com/taj-mahal.jpg" 
  },
  {
    name: "Red Fort",
    description: "The Red Fort is a historic fort in the city of Delhi, India.",
    imageUrl: "https://example.com/red-fort.jpg" 
  },
  // Add more places here
];

const placesList = document.getElementById("places-list");

places.forEach(place => {
  const placeContainer = document.createElement("div");
  placeContainer.classList.add("place-container");

  const placeName = document.createElement("h2");
  placeName.classList.add("place-name");
  placeName.textContent = place.name;

  const placeImage = document.createElement("img");
  placeImage.src = place.imageUrl;
  placeImage.alt = place.name;
  placeImage.style.width = "200px";
  placeImage.style.marginBottom = "10px";

  const placeDescription = document.createElement("p");
  placeDescription.classList.add("place-description");
  placeDescription.textContent = place.description.substring(0, 100) + "..."; 

  const showMoreButton = document.createElement("span");
  showMoreButton.classList.add("show-more");
  showMoreButton.textContent = "Show More";
  showMoreButton.addEventListener("click", () => {
    placeDescription.textContent = place.description;
    showMoreButton.style.display = "none";
  });

  placeContainer.appendChild(placeImage);
  placeContainer.appendChild(placeName);
  placeContainer.appendChild(placeDescription);
  placeContainer.appendChild(showMoreButton);

  placesList.appendChild(placeContainer);
});
