//
//  MockJob.swift
//
//  Created by David Martinez-Lebron on 3/1/19.
//  Copyright © 2019 dmlebron. All rights reserved.
//

import Foundation
@testable import DesignPatterns

struct MockJob {
    static var onlyTitleNameAndUrl: Job {
        return Job(title: "Software Developer",
                   companyUrlString: "www.google.com",
                   companyLogo: nil,
                   companyName: "Google",
                   type: nil,
                   description: nil,
                   location: nil)
    }

    static var onlyTitleLocationAndName: Job {
        return Job(title: "BackEnd Engineer",
                   companyUrlString: nil,
                   companyLogo: nil,
                   companyName: "LinkedIn",
                   type: nil,
                   description: nil,
                   location: "New York")
    }

    static var allFields: Job {
        return Job(title: "Finder UI Engineer",
                   companyUrlString: "http://www.apple.com",
                   companyLogo: "https://jobs.github.com/rails/active_storage/blobs/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBbkZjIiwiZXhwIjpudWxsLCJwdXIiOiJibG9iX2lkIn19--5e7296112e2452959b9ef5dda936d99908d6dfb7/Apple_300x300.jpeg",
                   companyName: "Apple Inc.",
                   type: "Full Time",
                   description: "<p>DESCRIPTION: Changing the world is all in a day\'s work at Apple. If you love innovation, here\'s your chance to make a career of it. You\'ll work hard. But the job comes with more than a few perks.</p>\n<p>Job Summary:\nDo you use Finder almost every day? Do you have ideas on how the popular file management tool could be even better? Are you passionate about designing, implementing and improving user interfaces? As a member of the Finder team, your every day will be spent enhancing the popular file management app -- you will be dreaming up and implementing new features, enhancing existing workflows and making the award-winning file management app even more efficient, intuitive and a pleasure to use. You will be a part of a team that is relentless in its pursuit of producing excellent, reliable code, spending considerable amounts of time on refining workflows and tuning for performance and responsiveness. You will have the opportunity to take features through all phases of the development cycle: idea, brainstorm, prototyping, design, development, refinement, bug fixing and performance tuning.</p>\n<p>Key Qualifications:</p>\n<ul>\n<li>Passion for designing and coding user interfaces and attention to detail Fluency in Obj-C, Swift or C++ Excellent software design, development and debugging skills</li>\n<li>You will prioritize tasks with rapid development cycles, remain flexible and calm in the face of uncertainty, and drive to deliver excellent results for time-critical issues.</li>\n<li>Be ready to make something great when you come here. Dynamic, inspiring people and innovative, industry-defining technologies are the norm at Apple. The people who work here have reinvented and defined entire industries with our products and services. The same passion for innovation also applies to our business practices - strengthening our commitment to leave the world better than we found it. You should join the Apple Finder team if you want to help deliver the next amazing Apple product.</li>\n<li>You have excellent judgment and integrity with the ability to make timely and sound decisions</li>\n<li>We value your passion for creativity and hard work</li>\n<li>Excellent writing and interpersonal skills</li>\n<li>Thorough knowledge of macOS and iOS is helpful</li>\n<li>Ability to stay focused and prioritize a heavy workload while achieving exceptional quality</li>\n<li>You are upbeat, adaptable, and results oriented with a positive attitude</li>\n<li>You bring passion and dedication to your job and are committed to our vision and supporting the developer community</li>\n</ul>\n<p>Description:\nIf you have expertise in AppKit, Core Animation and Core graphics, if you know Xcode, clang, lldb and instruments, if you know file systems, multi-treading and coding for performance in and out, you will be able to put your skills to work every day and hone them as you go. Outside of the Finder team, you will be working with teams throughout the software engineering organization, from kernel and networking to UI frameworks such and all the way to human interface design. Experience with iOS coding will also come in handy.</p>\n<p>Apple is an Equal Opportunity Employer that is committed to inclusion and diversity. We also take affirmative action to offer employment and advancement opportunities to all applicants, including minorities, women, protected veterans, and individuals with disabilities. Apple will not discriminate or retaliate against applicants who inquire about, disclose, or discuss their compensation or that of other applicants.</p>\n<p>REQUISITION NUMBER: 112924637\nCOMPANY NAME: Apple Inc.</p>\n",
                   location: "San Francisco, CA")
    }
}
