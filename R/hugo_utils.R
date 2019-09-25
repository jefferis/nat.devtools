#' Create an article from a rmarkdown file and add it in a hugo repository
#'
#' @param urlpath Path to the rmarkdown file (usually a location on the web)
#' @param foldername name of the folder to be created under `/content/articles/` like '2019-09-nat'
#' @param title Set the title of the article like 'article_xxx'
#' @param author Set the author name like sri, greg etc (corresponding to names in
#' the hugo repository)
#' @param categories Set the category of the article like 'learn', 'nat' etc.
#' @param description Set the description of the article like '`nat` version 1.8.13 is now on CRAN!'
#' @param slug Set the slug of the article like 'nat-1-8-13'
#' @param logourl_path Path to the square logo file that is displayed as favicon (usually a location on the web)
#' @param metadata_photo Set the metadata related to the photo to appear on the article (must be a wide figure)
#' like c(photoauthor, photo_url)
#' @export
#' @examples
#' \dontrun{
#' nat_hugo_addarticle(urlpath='https://raw.githubusercontent.com/natverse/nat/master/vignettes/NeuroGeometry.Rmd',
#' foldername = '2019-09-nat', title = 'NeuroGeometry - Analysing 3D morphology of neurons',
#' author = c('greg'), categories = c('learn','nat'), description = '`nat` version 1.8.13 is now on CRAN!',
#' slug = 'nat-1-8-13', logourl_path = 'https://raw.githubusercontent.com/natverse/natverse_hugo/dev_pages/content/articles/2019-09-nat/natverse_logo-sq.jpg',
#' metadata_photo = c('Maranda Vandergriff', 'https://unsplash.com/photos/o-d37kiKqqc'))
#'
#' nat_hugo_addarticle(urlpath='https://raw.githubusercontent.com/natverse/nat/master/vignettes/neurons-intro.Rmd',
#' foldername = '2019-09-neurons', title = 'Introduction to neurons and neuronlists',
#' author = c('greg'), categories = c('learn','nat'), description = '`nat` neurons and neuronlists!',
#' slug = 'nat',logourl_path = 'https://raw.githubusercontent.com/natverse/natverse_hugo/dev_pages/content/articles/2019-09-nat/natverse_logo-sq.jpg',
#' metadata_photo = c('Wikipedia', 'https://upload.wikimedia.org/wikipedia/commons/4/45/Wide_lightning.jpg'))
#' }
nat_hugo_addarticle <- function(urlpath,foldername,title,author,categories,description,
                                slug, logourl_path,metadata_photo) {


  # Step 1: First create folder and download rmd file there..
  articlepath <- file.path(here::here(),'content/articles',foldername)
  if(dir.exists(articlepath)){
    message('folder:', articlepath," already exists")
  }else{dir.create(articlepath)}

  rmdfile <- file.path(articlepath,'index.Rmarkdown' )
  mdfile <- file.path(articlepath,'index.markdown')
  unlink(mdfile) #Remove previously present files.

  # Step 2: Download to the folder here..
  utils::download.file(url=urlpath, destfile=rmdfile, method='curl')

  square_jpg <- file.path(articlepath,paste0(foldername,'_logo-sq.jpg'))
  utils::download.file(url=logourl_path, destfile=square_jpg, method='curl')

  wide_jpg <- file.path(articlepath,paste0(foldername,'-wd.jpg'))
  utils::download.file(url=metadata_photo[2], destfile=wide_jpg, method='curl')

  blogdown::serve_site() #this is to create md file and other figure contents

  # Step 3: Read contents of mdfile here..
  con = file(mdfile, "r+")
  res <- readLines(con)

  # Step 4: Remove the title lines..
  tempdata <- grepl(pattern = '---', res)
  tempres <- res
  cat('\n removing lines from', which(tempdata)[1], 'to', which(tempdata)[2], 'in markdown file \n')
  tempdata[which(tempdata)[1]:which(tempdata)[2]] <- TRUE
  tempres <- res[!tempdata]

  unlink(rmdfile) #This is to prevent the rmd file from triggering a build again.

  # Step 5: Construct metadata now..
  metadata <- paste0("\n---\ntitle: ", title,
                     "\nauthor:", paste(paste0("\n- ", author), collapse = ''),
                     "\ncategories:", paste(paste0("\n- ", categories), collapse = ''),
                     "\ndate: ", paste0("\"", Sys.Date(),"\""),
                     "\ndescription: |\n  ",description,
                     "\nphoto:", "\n  author: ", metadata_photo[1],
                     "\n  url: ", metadata_photo[2],
                     "\nslug: ", slug,
                     "\n---\n")

  tempmetadata <- unlist(strsplit(metadata,"\n" ))

  tempcont <- c(tempmetadata,tempres)

  writeLines(tempcont, con)

  close(con)


}
