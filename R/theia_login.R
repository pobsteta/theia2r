#' @title Import / export Theia username and password
#' @description Read the Theia login information or save new username and
#'  password. Login information is stored in a file `auth_theia.txt` inside the
#'  directory of `theia_download`. This functions allow to read or write this
#'  file, and to edit them from inside the GUI.
#' @param apitheia_path Path of the file in which login information is saved.
#'  If NA (default) it is automatically read from `theia_download` path.
#' @param username Theia username.
#' @param password Theia password.
#' @return NULL
#' @author Pascal Obstetar, (2018) \email{pascal.obstetar@@gmail.com}
#' @note License: GPL 3.0
#' @importFrom reticulate py_to_r
#' @importFrom shiny a actionButton icon modalButton modalDialog passwordInput tagList textInput
#' @importFrom shinyFiles shinyFileSave

#' @param apitheia_path 
#'
#' @name read_theia_login
#' @rdname theia_login
#' @export

read_theia_login <- function(apitheia_path=NA) {
  # if apitheia_path is not specified, 
  # retrieve from the current theia_download installation
  if (is.na(apitheia_path)) {
    # import theia_download
    theia_download <- import_theia_download(convert=FALSE)
    apitheia_path <- file.path(theia_download$inst_path,"auth_theia.txt")
    # apitheia_path <- file.path(py_to_r(theia_download$inst_path),"auth_theia.txt")
  }
  # return user and password
  if (file.exists(apitheia_path)) {
    readLines(apitheia_path)[1] %>%
      strsplit(" ") %>%
      unlist()
  } else {
    # if apitheia does not exists, return default credentials
    c("email","password")
  }
}


#' @param username 
#'
#' @param password 
#' @param apitheia_path 
#'
#' @name write_theia_login
#' @rdname theia_login
#' @export

write_theia_login <- function(username, password, apitheia_path=NA) {
  # if apitheia_path is not specified, 
  # retrieve from the current theia_download installation
  if (is.na(apitheia_path)) {
    # import theia_download
    theia_download <- import_theia_download(convert=FALSE)
    apitheia_path <- file.path(theia_download$inst_path,"auth_theia.txt")
  }
  # write credentials
  writeLines(
    paste(username, password),
    apitheia_path
  )
}

#' @name theia_modal
#' @rdname theia_login

# write dialog content
#' Title
#'
#' @param username 
#' @param password 
#'
#' @return
#' @export
#'
#' @examples
theia_modal <- function(username=NA, password=NA) {
  # read theia user/password
  if (anyNA(c(username,password))) {
    apitheia <- read_theia_login()
    username <- apitheia[1]
    password <- apitheia[2]
  }
  modalDialog(
    title = "Set Theia username and password",
    size = "s",
    textInput("theia_username", "Username", username),
    passwordInput("theia_password", "Password", password),
    a("Register new account", href="https://sso.theia-land.fr/theia/register/register.xhtml", target="_blank"),
    "\u2000\u2014\u2000",
    a("Forgot password?", href="https://sso.theia-land.fr/theia/profile/recovery.xhtml;jsessionid=49E3F76B9E96191C4ADDD3EE5298E366", target="_blank"),
    checkboxInput(
      "apitheia_default",
      label = span(
        "Store inside the package\u2000",
        actionLink("help_apitheia", icon("question-circle"))
      ),
      value = TRUE
    ),
    easyClose = FALSE,
    footer = tagList(
      div(style="display:inline-block;vertical-align:top;",
          conditionalPanel(
            condition = "output.switch_save_apihub == 'custom'",
            shinySaveButton(
              "apitheia_path_sel", 
              "Save as...", "Specify path for apitheia text file", 
              filetype=list(plain="txt"), 
              class = "theia_savebutton"
            )
          )),
      div(style="display:inline-block;vertical-align:top;",
          conditionalPanel(
            condition = "output.switch_save_apitheia == 'default'",
            actionButton(
              "save_apitheia", "\u2000Save", 
              icon=icon("save"), 
              class = "theia_savebutton"
            )
          )),
      div(style="display:inline-block;vertical-align:top;",
          modalButton("\u2000Cancel", icon = icon("ban")))
    )
  )
}

