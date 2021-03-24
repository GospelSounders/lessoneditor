<template>
    <!-- <q-layout view="lHh Lpr lFf"> -->
    <q-layout view="hHh Lpr lFf">
        <q-header elevated>
            <q-toolbar>
                <q-btn flat dense round icon="menu" aria-label="Menu" @click="leftDrawerOpen = !leftDrawerOpen" />
    
                <q-toolbar-title> Lesson Editor </q-toolbar-title>
            </q-toolbar>
        </q-header>
    
        <q-drawer ref="drawer" v-model="leftDrawerOpen" @mouseout="mouseOutofDrawer" overlay bordered :breakpoint="500" persist content-class="bg-primary text-white">
            <q-list>
                <q-item v-if="loggedIn" clickable @click="openLesson = true">
                    <q-item-section avatar>
                        <q-icon name="folder_open" />
                    </q-item-section>
                    <q-item-section>
                        <q-item-label>Open Lesson</q-item-label>
                    </q-item-section>
                </q-item>
                <q-separator />
                <q-item v-if="loggedIn" clickable @click="logout">
                    <q-item-section avatar>
                        <q-icon name="logout" />
                    </q-item-section>
                    <q-item-section>
                        <q-item-label>Log out</q-item-label>
                    </q-item-section>
                </q-item>
                <q-item v-if="!loggedIn" clickable @click="loginDialog = true">
                    <q-item-section avatar>
                        <q-icon name="login" />
                    </q-item-section>
                    <q-item-section>
                        <q-item-label>Log in</q-item-label>
                    </q-item-section>
                </q-item>
            </q-list>
        </q-drawer>
    
        <q-dialog v-model="openLesson" transition-show="rotate" transition-hide="rotate">
            <q-card>
                <q-card-section class="q-pt-md text-center text-h6">
                    Open Lesson
                    <q-separator />
                </q-card-section>
                <q-card-section>
                    <div>
                        <q-list>
                            <q-item tag="label" v-ripple>
                                <q-item-section avatar>
                                    <q-radio v-model="lessonType" val="missing" @input="changedLessonType" />
                                </q-item-section>
                                <q-item-section>
                                    <q-item-label>Missing</q-item-label>
                                    <q-item-label caption>Lessons in
                                        <a href="https://github.com/GospelSounders/all-pdf-lessons-in-pdf" target="_blank">pdf format</a
                        >
                        which have not been uploaded to
                        <a
                          href="https://sabbathschool.gospelsounders.org/1888-1890/1890/quarter4"
                          target="_blank"
                          >the site.</a
                        >
                      </q-item-label>
                    </q-item-section>
                  </q-item>
                  <q-item tag="label" v-ripple>
                    <q-item-section avatar>
                      <q-radio
                        v-model="lessonType"
                        val="existing"
                        @input="changedLessonType"
                      />
                    </q-item-section>
                    <q-item-section>
                      <q-item-label>Existing</q-item-label>
                      <q-item-label caption
                        >Lessons in which have been uploaded to
                        <a
                          href="https://sabbathschool.gospelsounders.org/1888-1890/1890/quarter4"
                          target="_blank"
                          >the site.</a
                        >
                      </q-item-label>
                    </q-item-section>
                  </q-item>
                  <q-item tag="label" v-ripple>
                    <q-item-section avatar>
                      <q-radio
                        v-model="lessonType"
                        val="all"
                        @input="changedLessonType"
                      />
                    </q-item-section>
                    <q-item-section>
                      <q-item-label>All</q-item-label>
                      <q-item-label caption
                        >All Lessons available in
                        <a
                          href="https://github.com/GospelSounders/all-pdf-lessons-in-pdf"
                          target="_blank"
                          >pdf format.</a
                        >
                      </q-item-label>
                    </q-item-section>
                  </q-item>
                </q-list>
              </div>
            </q-card-section>
            <q-card-section>
              <q-form
                @submit="onSubmitOpenLesson"
                @reset="onResetgtKey"
                class="q-gutter-md text-white"
              >
                <q-select
                  clearable
                  use-input
                  @filter="filterFn"
                  filled
                  v-model="selectedLesson"
                  :options="lessonsToOpen"
                  label="File"
                  lazy-rules
                  :rules="[
                    (val) => (val && val.length > 0) || 'Please select file',
                  ]"
                />
                <q-card-actions align="right">
                  <!-- <q-btn flat label="Decline" color="primary" v-close-popup /> -->
                  <!-- <q-btn flat label="Accept" color="primary" v-close-popup /> -->
                  <q-btn flat label="Cancel" color="primary" v-close-popup />
                  <q-btn flat label="Ok" color="primary" type="submit" />
                </q-card-actions>
              </q-form>
            </q-card-section>
          </q-card>
        </q-dialog>
        <q-dialog
          v-model="loginDialog"
          transition-show="rotate"
          transition-hide="rotate"
        >
          <q-card>
            <q-card-section class="q-pt-none text-center text-h6">
              Enter Key
            </q-card-section>
            <q-card-actions align="right">
              <q-form
                @submit="onSubmitgtKey"
                @reset="onResetgtKey"
                class="q-gutter-md text-white"
              >
                <q-input
                  filled
                  type="password"
                  v-model="gkKey"
                  label="Github Key"
                  lazy-rules
                  :rules="[
                    (val) =>
                      (val !== null && val !== '') || 'Please enter your key',
                  ]"
                  :error-message="gtKeyErrorMessage"
                />
                <div class="float-right">
                  <q-btn flat label="Cancel" color="primary" v-close-popup />
                  <q-btn flat label="Ok" type="submit" color="primary" />
                </div>
              </q-form>
            </q-card-actions>
          </q-card>
        </q-dialog>
    
        <q-page-container>
          <q-page class="full-height">
            <iframe
              ref="pageEditor"
              style="width: 100%; position: absolute; height: 100%; border: 0px"
              src="/#/blank"
            />
          </q-page>
          <q-page class="full-height">
            <textarea
              ref="pageEditorText"
              style="width: 100%; position: absolute; height: 100%; border: 0px"
              v-model="pageEditorText"
            />
          </q-page>
          <q-page-sticky position="bottom-right" :offset="[18, 18]">
            <q-fab
              ref="fabs"
              vertical-actions-align="right"
              color="secondary"
              glossy
              icon="keyboard_arrow_up"
              direction="up"
            >
              <!-- <q-fab-action
                                                                    label-position="left"
                                                                    color="primary"
                                                                    @click="clearBackground"
                                                                    label="Remove Background"
                                                                  />
                                                                  <q-fab-action
                                                                    label-position="left"
                                                                    color="secondary"
                                                                    @click="joinLines"
                                                                    label="Join Lines"
                                                                  /> -->
              <q-fab-action
                label-position="left"
                @click="deletePage"
                label="Delete Page"
              />
              <q-fab-action
                label-position="left"
                @click="detectParagraphs"
                label="Detect Paragraphs"
              />
              <q-fab-action
                label-position="left"
                @click="deleteHeaders"
                label="Delete Headers"
              />
            </q-fab>
          </q-page-sticky>
          <q-page-sticky position="bottom-left" :offset="[18, 18]">
            <q-btn round color="primary" icon="save" @click="saveExtractedFile" />
          </q-page-sticky>
          <q-page-sticky position="right" :offset="[18, 18]">
            <q-btn
              round
              color="primary"
              icon="navigate_next"
              @click="gotoNextPage"
            />
          </q-page-sticky>
          <q-page-sticky position="left" :offset="[18, 18]">
            <q-btn
              round
              color="primary"
              icon="navigate_before"
              @click="gotoPreviousPage"
            />
          </q-page-sticky>
        </q-page-container>
      </q-layout>
</template>

<script>
const { Octokit } = require("@octokit/rest");
import { QSpinnerGears } from "quasar";
const to = require("await-to-js").to;
const axios = require("axios");
const owner = "GospelSounders";
const pdfFilesRepo = "all-pdf-lessons-in-pdf";
const sabbathschoolRepo = "sabbathschool";
const repo = "ch1941.adh";
const settings = require("../services/values.json");
const allLessons = require("../services/allLessons.json");

export default {
    name: "MainLayout",
    components: {},
    computed: {
        // this.loggedIns = ths.loggedIn
    },
    created() {
        // check for credentials
        this.checkforCredentials();
        this.getAllLessons();
        this.getAllExistingLessons();
        this.changedLessonType();
        this.createAllLessonInfo();

        // this.$q.loading.show({
        //         message: false
        //           ? "Registering your account..."
        //           : "Authenticating your account...",
        //         backgroundColor: "grey",
        //         spinner: QSpinnerGears,
        //         customClass: "loader",
        //       });
    },
    data() {
        return {
            lessonType: "missing",
            pageEditorText: "",
            lines: [],
            allElements: [],
            leftDrawerOpen: false,
            openLesson: true,
            loginDialog: false,
            loggedIn: false,
            gkKey: null,
            gtKeyErrorMessage: "",
            allLessons: [],
            existingLessons: [],
            existings: [],
            lessonsToOpen: [],
            allLessonsToOpen: [],
            lessonsToOpen: [],
            selectedLesson: "",
        };
    },
    methods: {
        async readAllLessonsInfo() {

        },
        async createAllLessonInfo() {
            let [err, care] = await to(axios.get("https://raw.githubusercontent.com/GospelSounders/all-pdf-lessons-in-pdf/master/allLessonsInfo.json"))
            if (err) {
                [err, care] = await to(axios.get(`${settings["CORS_PROXY"]}/https://sabbathschool.gospelsounders.org/Sabbath-School/Sabbath-School-Lesson-Topics`))
                if (err) return false;
                care = care.data
                care = care.match(/<td><a href="\/[0-9]{4}-[0-9]{4}\/[0-9]{4}\/quarter([0-9])">[^<]*</g)
                let topics = care.map(item => {
                    return item.replace(/<[^>]*>/g, '').replace(/</, '')
                });
                let quarters = care.map(item => {
                    item = item.match(/a href="\/[0-9]{4}-[0-9]{4}\/[0-9]{4}\/quarter([0-9])"/g, '')[0].replace(/"/g, '').split('/')
                    let year = item[2];
                    let quarter = item[3].slice(-1);
                    while (quarter.length < 2) quarter = `0${quarter}`
                    return `${year}-${quarter}`
                });
                let lessonsInfo = {}
                for (let i in quarters) {
                    lessonsInfo[quarters[i]] = {
                        topic: topics[i]
                    }
                }
                // window.localStorage.getItem("allLessons")
                window.localStorage.setItem("allLessonsInfo", JSON.stringify(lessonsInfo));
                console.log(lessonsInfo)
                const octokit = new Octokit({
                    auth: this.loggedIn,
                });

                let path = "allLessonsInfo.json";
                [err, care] = await to(
                    octokit.request(`GET /repos/${owner}/${pdfFilesRepo}/contents/${path}`, {
                        owner: owner,
                        repo: pdfFilesRepo,
                        path: path,
                    })
                );
                let sha;
                if (!err) {
                    sha = care.data.sha;
                }
                let obj = {
                    owner: owner,
                    repo: pdfFilesRepo,
                    path: path,
                    message: path,
                    content: Buffer.from(JSON.stringify(lessonsInfo)).toString("base64"),
                };
                if (sha) {
                    obj.sha = sha;
                }
                [err, care] = await to(
                    octokit.request(`PUT /repos/${owner}/${pdfFilesRepo}/contents/${path}`, obj)
                );
            }
            if(!window.localStorage.getItem("allLessonsInfo")){
              ;[err, care] = await to(axios.get("https://raw.githubusercontent.com/GospelSounders/all-pdf-lessons-in-pdf/master/allLessonsInfo.json"))

              if(err)return err;
              care = care.data
              window.localStorage.setItem("allLessonsInfo", JSON.stringify(care));
            }
            return JSON.parse(window.localStorage.getItem("allLessonsInfo"));
        },
        getCurrentPage() {
            let iframe = this.$refs.pageEditor.contentWindow.document;
            let pageElements = iframe.getElementsByClassName("pf");
            let currentPage;
            for (let i in pageElements) {
                let foundPage = false;
                try {
                    if (pageElements[i].getBoundingClientRect().top >= 0) {
                        currentPage = pageElements[i];
                        break;
                    }
                } catch (err) {}
            }
            return currentPage;
        },
        getPageNumber(page) {
            console.log(page);
            let pageNumber;
            let tmpClassList = [];
            for (let i in page.classList) {
                let className = page.classList[i];
                if (className.match(/pc[0-9a-z]+/)) {
                    pageNumber = className;
                    break;
                }
            }
            pageNumber = pageNumber.slice(2);
            return pageNumber; //hex
        },
        getPageAnchor(pageNumber) {
            // hex
            let iframe = this.$refs.pageEditor.contentWindow.document;
            let anchors = iframe.getElementsByTagName("a");
            let nextAnchor;
            for (let i in anchors) {
                if (anchors[i].href.split("/").slice(-1)[0] === `#pf${pageNumber}`) {
                    return anchors[i];
                    break;
                    nextAnchor = anchors[i];
                }
            }
        },
        removePageAnchor(page) {
            let anchor = this.getPageAnchor(this.getPageNumber(page));
            anchor.parentNode.removeChild(anchor);
        },
        deleteHeaders() {
            let page = this.getCurrentPage();
            page = page.children[0];
            let children = [];
            for (let i in page.children) {
                let child = page.children[i];
                children.push(child);
            }
            children = children.filter((item) => {
                try {
                    item.getBoundingClientRect();
                    return item;
                } catch (err) {
                    return false;
                }
            });
            children = children.sort((a, b) => {
                let aX = a.getBoundingClientRect().x;
                let aY = a.getBoundingClientRect().y;
                let bX = b.getBoundingClientRect().x;
                let bY = b.getBoundingClientRect().y;
                return aY - bY;
                //   return Math.hypot(aX, aY) - Math.hypot(bX, bY)
                //   a.getBoundingClientRect().y - b.getBoundingClientRect().y && a.getBoundingClientRect().x - b.getBoundingClientRect().x;
                //   a.getBoundingClientRect().x - b.getBoundingClientRect().x && a.getBoundingClientRect().y - b.getBoundingClientRect().y
            });
            let header = children[0];
            header.parentNode.removeChild(header);
            let pageNumber = this.getPageNumber(page);
            // let iframe = this.$refs.pageEditor.contentWindow.document;
            // // let pageElements = iframe.getElementsByClassName('pf');
            // let anchors = iframe.getElementsByTagName('a');
            // let nextNumber = parseInt(pageNumber, 16) + 1;
            // // console.log('nextNumber, ', nextNumber, pageNumber)
            // nextNumber = nextNumber.toString(16);
            // let nextAnchor;
            // for (let i in anchors) {
            //     // if(anchors[i].getAttribute('href')===`#pf${nextNumber}`)

            //     if (anchors[i].href.split('/').slice(-1)[0] === `#pf${nextNumber}`) {
            //         // console.log()
            //         // console.log(anchors[i].href, nextNumber)
            //         anchors[i].click();
            //         break;
            //         nextAnchor = anchors[i]
            //     }
            // }
            // console.log(pageNumber);
            this.$refs.fabs.show();
            // page.parentNode.removeChild(page)
        },
        gotoNextPage() {
            let page = this.getCurrentPage();
            page = page.children[0];
            let pageNumber = this.getPageNumber(page);
            let iframe = this.$refs.pageEditor.contentWindow.document;
            let anchors = iframe.getElementsByTagName("a");
            let nextNumber = parseInt(pageNumber, 16) + 1;
            console.log(nextNumber);
            nextNumber = nextNumber.toString(16);
            let nextAnchor;
            for (let i in anchors) {
                try {
                    if (anchors[i].href.split("/").slice(-1)[0] === `#pf${nextNumber}`) {
                        // let tmpSrcDoc = iframe.contentDocument.outerHTML;
                        // // iframe.srcdoc = 'tmpSrcDoc' document.documentElement.outerHTML
                        // this.$refs.pageEditor.srcdoc = tmpSrcDoc
                        // console.log(anchors[i].href.split('/').slice(-1)[0])
                        anchors[i].click();
                        break;
                        nextAnchor = anchors[i];
                    }
                } catch (err) {}
            }
        },
        gotoPreviousPage() {
            let page = this.getCurrentPage();
            page = page.children[0];
            let pageNumber = this.getPageNumber(page);
            let iframe = this.$refs.pageEditor.contentWindow.document;
            let anchors = iframe.getElementsByTagName("a");
            let nextNumber = parseInt(pageNumber, 16) - 1;
            nextNumber = nextNumber.toString(16);
            let nextAnchor;
            for (let i in anchors) {
                try {
                    if (anchors[i].href.split("/").slice(-1)[0] === `#pf${nextNumber}`) {
                        anchors[i].click();
                        break;
                        nextAnchor = anchors[i];
                    }
                } catch (err) {}
            }
        },
        deletePage() {
            let currentPage = this.getCurrentPage();
            this.removePageAnchor(currentPage.children[0]);
            currentPage.parentNode.removeChild(currentPage);
            let pageNumber = this.getPageNumber(currentPage.children[0]);
            let deletedPageNumber = parseInt(pageNumber, 16);
            setTimeout(() => {
                let iframe = this.$refs.pageEditor.contentWindow.document;
                let pages = iframe.getElementsByClassName("pc");
                for (let i in pages) {
                    let page = pages[i];
                    for (let i in page.classList) {
                        let className = page.classList[i];
                        if (className.match(/pc[0-9a-z]+/)) {
                            pageNumber = parseInt(className.slice(2), 16);
                            if (pageNumber > deletedPageNumber) {
                                pageNumber--;
                                let newClassName = "pc" + pageNumber.toString(16);
                                page.classList.remove(className);
                                page.classList.add(newClassName);
                                page.parentElement.setAttribute(
                                    `data-page-no`,
                                    pageNumber.toString(16)
                                );
                                page.parentElement.id = "pf" + pageNumber.toString(16);
                            }

                            break;
                        }
                    }
                }

                let anchors = iframe.getElementsByTagName("a");
                for (let i in anchors) {
                    try {
                        let href = anchors[i].href.split("/").slice(-1)[0];
                        if (href.match(/#pf[0-9a-z]+/)) {
                            pageNumber = parseInt(href.slice(3), 16);
                            if (pageNumber > deletedPageNumber) {
                                pageNumber--;
                                let dataDestDetail = anchors[i].getAttribute(
                                    "data-dest-detail"
                                );
                                dataDestDetail = JSON.parse(dataDestDetail);
                                dataDestDetail[0]--;
                                anchors[i].setAttribute(
                                    "data-dest-detail",
                                    JSON.stringify(dataDestDetail)
                                );
                                anchors[i].href = "#pf" + pageNumber.toString(16);
                                anchors[i].innerHTML = "page" + pageNumber;
                            }
                        }
                    } catch (err) {}
                }
                iframe = this.$refs.pageEditor.contentWindow.document;
                let tmpSrcDoc = this.$refs.pageEditor.contentWindow.document
                    .documentElement.outerHTML;
                this.$refs.pageEditor.srcdoc = tmpSrcDoc;
            }, 1000);
        },
        async getAllLessons() {
            // if (!window.localStorage.getItem("allLessons")) {
            //   let [err, care] = await to(axios.get(
            //     `https://raw.githubusercontent.com/${owner}/${pdfFilesRepo}/master/allLessons.json`
            //   ));
            //   if (err) return false;
            //   window.localStorage.setItem("allLessons", JSON.stringify(care.data))
            // }
            // return JSON.parse(window.localStorage.getItem("allLessons"));
            return allLessons;
        },
        async getAllExistingLessons(read = false) {
            if (!window.localStorage.getItem("allExistingLessons") || read) {
                let [err, care] = await to(
                    axios.get(
                        `${settings["CORS_PROXY"]}/https://sabbathschool.gospelsounders.org/sitemap.xml`
                    )
                );
                if (err) return false;
                care = care.data;
                let locs = care.match(/<loc>[^<]*<\/loc>/g);
                let quarters = {};
                locs = locs
                    .filter((item) => item.match(/[0-9]{4}\/quarter[0-9]/))
                    .map((item) => item.match(/[0-9]{4}\/quarter[0-9]/)[0]);
                // console.log(locs);
                locs.map((quarter) => {
                    if (quarters[quarter] === undefined) {
                        quarters[quarter] = 1;
                    } else {
                        quarters[quarter] += 1;
                    }
                });
                let quartersArr = [];
                for (let i in quarters) quartersArr.push([i, quarters[i]]);
                // console.log(quartersArr)
                let existingQuarters = quartersArr.filter(item => item[1] > 1).map(item => item[0]);
                // console.log(existingQuarters)
                window.localStorage.setItem("allExistingLessons", JSON.stringify(existingQuarters))
            }
            return JSON.parse(window.localStorage.getItem("allExistingLessons"));
        },
        async changedLessonType() {
            this.$q.loading.show({
                message: "Fetching List",
                backgroundColor: "grey",
                spinner: QSpinnerGears,
                customClass: "loader",
            });
            return new Promise(async (resolve, reject) => {
                // let [err, care] = await to(a)
                const octokit = new Octokit({
                    auth: this.loggedIn,
                });

                // let path = "htmlFiles/SS18880101-01.html";
                let path = "htmlFiles";
                // let [err, care] = await to(
                //   octokit.request(
                //     `GET /repos/${owner}/${pdfFilesRepo}/contents/${path}`,
                //     {
                //       owner: owner,
                //       repo: pdfFilesRepo,
                //       path: path,
                //     }
                //   )
                // );
                // let [err, care] = await to(
                //   octokit.request(
                //     `GET /repos/${owner}/${pdfFilesRepo}/contents/${path}`,
                //     {
                //       owner: owner,
                //       repo: pdfFilesRepo,
                //       path: path,
                //     }
                //   )
                // );
                // this.$q.loading.hide();
                // if (err) {
                //   return resolve(false);
                // }
                // let allLessons = care.data;
                let allLessons = await this.getAllLessons();
                console.log('-------------')
                console.log('-------------', allLessons)
                this.allLessons = allLessons.map((item) =>
                    item.slice(2).replace(".html", "")
                    // item.name.slice(2).replace(".html", "")
                );


                //  let existings_ = this.existings;
                switch (this.lessonType) {
                    case "all":
                        this.allLessonsToOpen = this.allLessons;
                        break;
                    case "missing":
                        let allExistingLessons = await this.getAllExistingLessons()
                        this.allLessonsToOpen = this.allLessons.filter((item) => {
                            let tmpItem = item;
                            // let thisYear = `${tmpItem.slice(0, 4)}-${item.slice(9, 11)}`;
                            let thisYear = `${tmpItem.slice(0, 4)}`;
                            let thisQuarter = parseInt(`${item.slice(9, 11)}`)
                            // console.log(item, thisYear, thisQuarter);
                            return !allExistingLessons.includes(`${thisYear}/quarter${thisQuarter}`);
                        });
                        break;
                    case "existing":
                        this.openLesson = false;
                        this.$q.notify({
                            type: "negative",
                            message: "Not yet implemented",
                        });
                        break;
                }

                this.$q.loading.hide();
                return resolve(true);

                let existingHierarchy = [];
                let tenYears = [];
                let years = [];
                let quarters = [];
                let tmp = [];
                for (let i = 1888; i <= 2000; i++) {
                    if (tmp.length === 0) {
                        tmp.push(i);
                    }
                    if (i % 10 === 0) {
                        tmp.push(i);
                        tenYears.push(tmp);
                        tmp = [];
                    }
                }
                let tenYearInd = 2;
                let yearPaths = [];
                for (let i in tenYears) {
                    let startYear = tenYears[i][0];
                    let endYear = tenYears[i][1];
                    let yearInd = 1;
                    let tenYearIndTmp = tenYearInd.toString();
                    while (tenYearIndTmp.length < 2) tenYearIndTmp = `0${tenYearIndTmp}`;
                    for (let j = startYear; j <= endYear; j++) {
                        let yearIndTmp = yearInd.toString();
                        while (yearIndTmp.length < 2) yearIndTmp = `0${yearIndTmp}`;
                        // console.log(`${tenYearIndTmp}.${startYear}-${endYear}/${yearIndTmp}.${j}`)
                        yearPaths.push(
                            `${tenYearIndTmp}.${startYear}-${endYear}/${yearIndTmp}.${j}`
                        );
                        yearInd++;
                    }
                    tenYearInd++;
                }
                // console.log(tenYears);
                let lessonPaths = [];
                for (let i in yearPaths) {
                    lessonPaths.push(`${yearPaths[i]}/01.quarter1`);
                    lessonPaths.push(`${yearPaths[i]}/02.quarter2`);
                    lessonPaths.push(`${yearPaths[i]}/03.quarter3`);
                    lessonPaths.push(`${yearPaths[i]}/04.quarter4`);
                }

                // console.log(yearPaths);
                if (this.existings.length === 0) {
                    this.$q.loading.show({
                        message: "Fetching List",
                        backgroundColor: "grey",
                        spinner: QSpinnerGears,
                        customClass: "loader",
                    });
                    const checkIfExisting = async (path) => {
                        return new Promise(async (resolve) => {
                            let [err, care] = await to(
                                octokit.request(
                                    `GET /repos/${owner}/${sabbathschoolRepo}/contents/${path}`, {
                                        owner: owner,
                                        repo: sabbathschoolRepo,
                                        path: path,
                                    }
                                )
                            );
                            this.$q.loading.hide();
                            if (err) return resolve(false);
                            if (care.data.length === 1) return resolve(false);
                            else return resolve(path);
                        });
                    };
                    let promises = lessonPaths.map(checkIfExisting);
                    [err, care] = await to(Promise.all(promises));
                    care = care.filter((item) => item !== false);
                    let existings = [];
                    care.map((item) => {
                        let year = item.split("/").slice(-2)[0].split(".").slice(-1)[0];
                        let quarter = item.split("/").slice(-1)[0].slice(-1);
                        while (quarter.length < 2) quarter = `0${quarter}`;
                        existings.push(`${year}-${quarter}`);
                    });
                    this.existings = existings;
                }

                let existings = this.existings;
                switch (this.lessonType) {
                    case "all":
                        this.allLessonsToOpen = this.allLessons;
                        break;
                    case "missing":
                        this.allLessonsToOpen = this.allLessons.filter((item) => {
                            let tmpItem = item;
                            let thisYear = `${tmpItem.slice(0, 4)}-${item.slice(9, 11)}`;
                            // console.log(item, thisYear);
                            return !existings.includes(thisYear);
                        });
                        break;
                    case "existing":
                        this.openLesson = false;
                        this.$q.notify({
                            type: "negative",
                            message: "Not yet implemented",
                        });
                        break;
                }
            });
        },
        clearBackground() {
            let iframe = this.$refs.pageEditor.contentWindow.document;
            for (let i = 0; i < 20; i++) {
                let bgImage = iframe.getElementsByTagName("img");
                for (let i in bgImage) {
                    let img = bgImage[i];
                    try {
                        img.parentNode.removeChild(img);
                    } catch (err) {}
                }
            }

            var style = document.createElement("style");
            style.type = "text/css";
            style.innerHTML = `
              .bordered{
              border: 1px solid green;
              }
              `;
            iframe.getElementsByTagName("head")[0].appendChild(style);

            // let page = iframe.getElementById("pf1");
            // let pages = iframe.getElementByClassName("pf");

            // page = page.children[0];
            // for (let i in page.children) {
            //     let child = page.children[i];

            //     try {
            //         if (!child.style) {
            //             child.style = {};
            //         }
            //     } catch (err) {}

            //     // this.detectLines();
            // }
            this.detectLines();
            // this.detectParagraphs();
        },
        joinLines() {
            let iframe = this.$refs.pageEditor.contentWindow.document;
            // let page = iframe.getElementById("pf1");

            let pages = iframe.getElementsByClassName("pf");

            let passAllElements = [];
            for (let i in pages) {
                try {
                    let page = pages[i];
                    // console.log(page)
                    page = page.children[0];
                    let children = [];
                    for (let i in page.children) {
                        let child = page.children[i];
                        children.push(child);
                    }
                    children = children.filter((item) => {
                        try {
                            item.getBoundingClientRect();
                            return item;
                        } catch (err) {
                            return false;
                        }
                    });
                    children = children.sort((a, b) => {
                        let aX = a.getBoundingClientRect().x;
                        let aY = a.getBoundingClientRect().y;
                        let bX = b.getBoundingClientRect().x;
                        let bY = b.getBoundingClientRect().y;
                        return aY - bY;
                        //   return Math.hypot(aX, aY) - Math.hypot(bX, bY)
                        //   a.getBoundingClientRect().y - b.getBoundingClientRect().y && a.getBoundingClientRect().x - b.getBoundingClientRect().x;
                        //   a.getBoundingClientRect().x - b.getBoundingClientRect().x && a.getBoundingClientRect().y - b.getBoundingClientRect().y
                    });
                    children.map((item) => passAllElements.push(item));
                } catch (err) {}
            }
            this.allElements = passAllElements;
            // this.allElements = children;
        },
        detectLines() {
            this.detectLines_();
        },
        detectLines_() {
            this.joinLines();
            this.pageEditorText = "";
            let allElements = this.allElements;
            let lines = [];
            let line = [];
            for (let i in allElements) {
                let elem = allElements[i];
                if (line.length === 0) {
                    line.push(elem);
                } else {
                    let oldItem = line[line.length - 1].getBoundingClientRect();
                    let oldBottom = oldItem.top - oldItem.height;

                    let thisItem = elem.getBoundingClientRect();
                    let thisBottom = thisItem.top - thisItem.height;
                    let lesserHeight =
                        oldItem.height < thisItem.height ? oldItem.height : thisItem.height;
                    if (Math.abs(oldBottom - thisBottom) < lesserHeight * 0.5) {
                        line.push(elem);
                    } else {
                        line = line.sort((a, b) => {
                            let aX = a.getBoundingClientRect().x;
                            let aY = a.getBoundingClientRect().y;
                            let bX = b.getBoundingClientRect().x;
                            let bY = b.getBoundingClientRect().y;
                            return aX - bX;
                        });
                        let lineData = "";
                        for (let i in line) {
                            lineData += line[i].innerHTML;
                        }
                        line[0].innerHTML = `${lineData}`;
                        // line[0].innerHTML = `${lines.length}-->${lineData}`;
                        this.pageEditorText += `\n${lineData.replace(/<[^>]+>/g, "")}`;
                        for (let i in line) {
                            if (i > 0) {
                                line[i].parentNode.removeChild(line[i]);
                            }
                        }
                        lines.push(line);
                        line = [];
                        line.push(elem);
                    }
                }
                this.lines = lines;
            }
        },

        detectParagraphs() {
            this.detectLines();
            window.abc = this.lines[0];
            console.log(this.lines[1]);
            console.log(this.lines[2]);
            console.log(this.lines[3]);
            console.log(this.lines[0].getBoundingClientRect().x);
            console.log(this.lines[1].getBoundingClientRect().x);
            console.log(this.lines[2].getBoundingClientRect().x);
            console.log(this.lines[3].getBoundingClientRect().x);
            console.log(this.lines[4].getBoundingClientRect().x);
        },

        filterFn(val, update) {
            if (val === "") {
                update(() => {
                    this.lessonsToOpen = this.allLessonsToOpen;
                });
                return;
            }

            update(() => {
                const needle = val.toLowerCase();
                this.lessonsToOpen = this.allLessonsToOpen.filter(
                    (v) => v.toLowerCase().indexOf(needle) > -1
                );
            });
        },
        logout() {
            window.localStorage.removeItem("adhGitKey");
            this.checkforCredentials();
        },
        async saveExtractedFile() {
            let hymnNumber = this.pageEditorText.split("\n")[1];
            // console.log(hymnNumber);
            if (parseInt(hymnNumber).toString() === hymnNumber) {
                hymnNumber = hymnNumber;
                while (hymnNumber.length < 3) hymnNumber = `0${hymnNumber}`;
            } else {
                hymnNumber = this.selectedLesson;
            }
            // console.log(hymnNumber);
            let path = `extracted/${hymnNumber}`;

            const octokit = new Octokit({
                auth: this.loggedIn,
            });

            let [err, care] = await to(
                octokit.request(`GET /repos/${owner}/${repo}/contents/${path}`, {
                    owner: owner,
                    repo: repo,
                    path: path,
                })
            );
            let sha;
            if (!err) {
                sha = care.data.sha;
            }
            let obj = {
                owner: owner,
                repo: repo,
                path: path,
                message: path,
                content: Buffer.from(this.pageEditorText).toString("base64"),
            };
            if (sha) {
                obj.sha = sha;
            }
            [err, care] = await to(
                octokit.request(`PUT /repos/${owner}/${repo}/contents/${path}`, obj)
            );
        },
        async nextOriginalFile() {
            if (this.selectedLesson === "") this.selectedLesson = "page1";
            else {
                let tmp = parseInt(this.selectedLesson.replace("page", ""));
                tmp++;
                this.selectedLesson = `page${tmp}`;
            }
            this.onSubmitOpenLesson();
        },
        async prevOriginalFile() {
            if (this.selectedLesson === "") this.selectedLesson = "page1";
            else {
                let tmp = parseInt(this.selectedLesson.replace("page", ""));
                tmp--;
                if (tmp < 1) tmp = 1;
                this.selectedLesson = `page${tmp}`;
            }
            this.onSubmitOpenLesson();
        },
        async onSubmitOpenLesson() {
            return new Promise(async (resolve, reject) => {
                const octokit = new Octokit({
                    auth: this.loggedIn,
                });
                // let owner = "GospelSounders";
                // let repo = "ch1941.adh";
                let path = `htmlFilesNoImages/SS${this.selectedLesson}.html`;
                let [err, care] = await to(
                    axios.get(
                        `https://raw.githubusercontent.com/${owner}/${pdfFilesRepo}/master/${path}`
                    )
                );
                this.openLesson = false;
                if (err) {
                    return resolve(false);
                }
                care = care.data;
                care = care.replace(";color:transparent", ";color:black");
                care = care.replace("{color:transparent", "{color:black");
                care = care.replace(".t{", ".t{border:1px solid green;");
                // care = care.replace(/b\.getAttribute\("data-dest-detail"\);"/g, `b.getAttribute("data-dest-detail");alert("...");b.classList.add("asudo");`);
                // this.$refs.pageEditor.contentDocument.write(care);
                this.$refs.pageEditor.srcdoc = care;
                setTimeout(() => {
                    this.clearBackground();
                }, 2000);
                let selectedYear = this.selectedLesson.split('-')[0].substring(0,4);
                let selectedQuarter = this.selectedLesson.split('-')[1].substring(0,2);
                let key = `${selectedYear}-${selectedQuarter}`
                let allLessonsInfoTmp = await this.createAllLessonInfo()
                this.lessonTopic = allLessonsInfoTmp[key]                
            });
        },
        onSubmitgtKey() {
            window.localStorage.setItem("adhGitKey", this.gkKey);
            this.checkforCredentials();
            this.loginDialog = false;
        },
        onResetgtKey() {},
        checkforCredentials() {
            let hasGitCredentials = window.localStorage.getItem("adhGitKey");
            this.loggedIn = hasGitCredentials;
        },
        mouseOutofDrawer(pos) {
            if (Math.abs(pos.clientX - this.$refs.drawer.width) < 5) {
                this.leftDrawerOpen = false;
            }
        },
        // originalFilesList() {
        //   let ret = {};
        //   this.allOriginals = [];
        //   for (let i = 1; i <= 637; i++) {
        //     ret[i] = `page${i}`;
        //     this.allOriginals.push(ret[i]);
        //   }
        // },
    },
};
</script>
