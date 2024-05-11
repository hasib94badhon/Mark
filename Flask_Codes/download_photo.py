import requests
from bs4 import BeautifulSoup
import os

def download_images_from_anchor(url, folder_name, anchor_text):
    # Create a directory to save images
    if not os.path.exists(folder_name):
        os.makedirs(folder_name)
    
    # Get the HTML content from the URL
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')
    
    # Find the anchor tag by its text
    anchor = soup.find('a', string=anchor_text)
    if anchor and anchor.has_attr('href'):
        section_id = anchor['href'].strip('#')
        section = soup.find(id=section_id)
        if section is None:
            print(f"No section found with id {section_id}")
            return
        
        # Find all image tags within the section
        images = section.find_all('img')
        for i, image in enumerate(images):
            img_url = image['src']
            img_data = requests.get(img_url).content
            
            # Write the image data to a file
            with open(f'{folder_name}/image_{i+1}.jpg', 'wb') as handler:
                handler.write(img_data)
            
            print(f"Downloaded image {i+1} from section {section_id}")
    else:
        print("Anchor text not found or has no href attribute")

# Replace 'your_published_link' with your actual URL
url = 'https://docs.google.com/spreadsheets/d/e/2PACX-1vSPVUlUKCqFTqZG7VpNfXTDfAsjIkiL5PYCGBjbL4K90AFt-8iL-CqMtMZjVh16deGUXEN-DoUTx1xQ/pubhtml#'
anchor_text = 'Service'  # Replace with the actual text of the anchor
download_images_from_anchor(url, 'downloaded_images', anchor_text)
